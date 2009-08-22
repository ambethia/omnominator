google.load("maps", "2");

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
    addNewOmnom({
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
  jQuery.each(business.categories, function() {
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
      map.clearOverlays();
      if (data.businesses.length > 0) {
        for(var i = 0; i < data.businesses.length; i++) {
          var business = data.businesses[i];
          var position = new GLatLng(business.latitude, business.longitude);
          createMapMarker(business, position, i);
        }
      } else {
        // do something here
        console.log("No businesses found.");
      }
    }
    else {
      console.log("Yelp Error: " + data.message.text);
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

function doGeoLocation(query) {
  geocoder.getLatLng(query, function(point) {
    if (!point) {
      console.log("Couldn't geolocate '"+query+"'")
    } else {
      map.setCenter(point, 12);
    }
  });
}

function addNewOmnom(omnom) {
  var template = $.template('<li><span class="name">${name}</span><br/><span class="details">${details}</span></li>');
  var nom_item = template.apply(omnom);
  $("#sum_omnoms").append(nom_item).children(':last').hide().blindDown();
}

$(document).ready(function() {
  initializeMap();
  initializeMarkers();

  geocoder = new GClientGeocoder();

  $("#location_form").submit(function() {
    doGeoLocation($("#location_text").get(0).value);
    return false;
  });
  
  $("#categories li input").change(function() {
    yelp();
  });
  
  $("#tooltip").hide();

  $("#new_omnom").submit(function() {
    addNewOmnom({
      name: this.new_omnom_name.value,
      details: this.new_omnom_details.value
    });
    return false;
  });
});