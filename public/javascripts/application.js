google.load("maps", "2");

var MAX_OMNOMS = 5;

function initializeMap() {  
  var zoom     = 3;
  var latLng   = new GLatLng(39.50, -98.35);
  var location = "Anytown, USA";
  if (google.loader.ClientLocation) {
    zoom = 12;
    latLng = new GLatLng(
      google.loader.ClientLocation.latitude,
      google.loader.ClientLocation.longitude
    );
    location = formattedClientLocation();
  }
  $("#location_text").get(0).value = location;
  map = new GMap2($("#map_canvas").get(0));
  GEvent.addListener(map, "moveend", function() { yelp(); });
  map.setCenter(latLng, zoom);
  map.setUIToDefault();
}

function initializeMarkers() {
  var icon        = new GIcon();
  icon.image      = "/images/markers/yelp_star.png";
  icon.shadow     = "/images/markers/yelp_shadow.png";
  icon.iconSize   = new GSize(20, 29);
  icon.shadowSize = new GSize(38, 29);
  icon.iconAnchor = new GPoint(15, 29);  
  
  var sushi       = new GIcon(icon, "/images/markers/sushi.png")
  
  categoryIcons = {
    "sushi":      sushi
  }
  
  defaultIcon = icon;
};

function formattedClientLocation() {
  var address = google.loader.ClientLocation.address;
  if (address.country_code == "US" && address.region) {
    return address.city + ", " + address.region.toUpperCase();
  } else {
    return address.city + ", " + address.country_code;
  }
}

function createMapMarker(business, position, index) {
  var info        = markupForTooltip(business);
  var icon        = getBusinessIcon(business);
  var marker      = new GMarker(position, icon);
  
  GEvent.addListener(marker, "mouseover",function() { showTooltip(this, info) });
  GEvent.addListener(marker, "mouseout", function() { $("#tooltip").fadeOut() });
  GEvent.addListener(marker, "click",    function() {
    var yelp_details = {
      address: [business.address1, business.address2, business.address3].join(" "),
      phone: business.phone,
      url: business.url
    }
    var details = $.template('${address}<br/>${phone} (<a href="${url}">Reviews</a>)').apply(yelp_details);
    addNom({
      name: business.name,
      details: details
    })
  });
  map.addOverlay(marker);
}

function markupForTooltip(business) {
  var text = '';
  text += business.name;
  // add more stuff here
  return text;
}

function showTooltip(marker, infoHTML) {
  var tooltip   = $("#tooltip");
  var bounds    = map.getBounds();
  var icon      = marker.getIcon();
  var top       = -999;
  var left      = -999;

  tooltip.html("<div class='content'>"+infoHTML+"</div>");  
  if(bounds.contains(marker.getPoint())) {
    var mapPx = $(map.getContainer()).position();
    var pinPx = map.fromLatLngToContainerPixel(marker.getPoint());    
    top  = (pinPx.y + mapPx.top)  - (icon.iconAnchor.y + tooltip.height());
    left = (pinPx.x + mapPx.left) - (icon.iconAnchor.x + tooltip.width());
    if (left < 10) { left = 10 }; // keep it on the page
  }
  tooltip.css({ top: top, left: left }).fadeIn();
}

function getBusinessIcon(business) {
  var icon = null;
  $.each(business.categories, function() {
    icon = categoryIcons[this.category_filter];
    if (icon)
      return false;
  });
  return icon || defaultIcon;
}

function yelp() {
  var bounds = map.getBounds();
  var URI = "http://api.yelp.com/business_review_search?" +
            "&num_biz_requested=10&callback=?" +
            "&category=" + categoriesFilterString() +
            "&tl_lat="   + bounds.getSouthWest().lat() +
            "&tl_long="  + bounds.getSouthWest().lng() + 
            "&br_lat="   + bounds.getNorthEast().lat() + 
            "&br_long="  + bounds.getNorthEast().lng() +
            "&ywsid="    + "kIXgBO4ryiAN3oPxskwNmg";
  $.getJSON(URI, function(data){
    if(data.message.text == "OK") {
      $("#yelp_message").text("Om nom nom nom...")
      map.clearOverlays();
      if (data.businesses.length > 0) {
        for(var i = 0; i < data.businesses.length; i++) {
          var business = data.businesses[i];
          var position = new GLatLng(business.latitude, business.longitude);
          createMapMarker(business, position, i);
        }
      } else {
        $("#yelp_message").text("No noms... qq.")
      }
    }
    else {
      var message = data.message.text;
      if (message == "Area too large") {
        $("#yelp_message").text("Zoom moar!");
      } else {
        $("#yelp_message").text("Error: " + message);
      }
    }
  });
}

function categoriesFilterString() {
  var inputs  = $("#categories li input");
  var filters = [];

  inputs.each(function() {
    if (this.checked) {
      filters.push(this.value);
    }
  });
  if (filters.length > 0 && filters.length < inputs.length) {
    return filters.join("+");
  } else {
    return "restaurants";
  }
}

function iCanHazLocation(query) {
  geocoder.getLatLng(query, function(point) {
    if (!point) {
      $.flash.failure("A Google says wut?", "Can't geolocate: " + query);
    } else {
      map.setCenter(point, 12);
    }
  });
}

function addNom(omnom) {
  var list = $("#sum_noms");
  if (list.children("li").length < MAX_OMNOMS) {
    var template = $.template('<li><div class="name">${name}</div><div class="details">${details}</div><div class="remove">X</div></li>');
    var nom_item = template.apply(omnom);
    list.append(nom_item).children(':last').hide().blindDown();
    $("#sum_noms .remove").click(removeNom);
  } else {
    $.flash.warn("My belly hurts", "Too much noms.")
  };
  $("#new_nom").reset();
}

function removeNom() {
  $(this).parent().blindUp().remove();
}

function createOmnom() {
  $.ajax({
    type: "POST",
    url: "/omnom",
    cache: false,
    data: {
        authenticity_token: window._token,
        pplz: $("#sum_pplz").serialize()
    },
    error: function(XMLHttpRequest, textStatus, errorThrown)
    {
      try
      {
        var json = JSON.parse( XMLHttpRequest.responseText );
        
        var first_error = json[0][1];

        $.flash.failure("Oh, no you didn't", first_error);
      }
      catch(e)
      {
      }
      return false;
    },
    success: function(response)
    {
      try
      {
        var json = JSON.parse( response );
        top.location.href = json.redirect_to;
      }
      catch(e)
      {
      }
    }
   });

   return false;
}

$(document).ready(function() {
  initializeMap();
  initializeMarkers();

  geocoder = new GClientGeocoder();

  $("#location_form").submit(function() {
    iCanHazLocation($("#location_text").get(0).value);
    return false;
  });
  
  $("#categories li input").change(function() {
    yelp();
  });
  
  $("#tooltip").hide();

  $("#new_nom").submit(function() {
    addNom({
      name: this.new_nom_name.value,
      details: this.new_nom_details.value
    });
    return false;
  });

  $("#sum_pplz").submit(function() {
    createOmnom();
    return false;
  });

  $("#sum_noms .remove").click(removeNom);
});