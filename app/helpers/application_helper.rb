module ApplicationHelper

  def genre_input_list
    items = [
      ["Americana", "newamerican+tradamerican+bbq+chicken_wings+hotdog+soulfood+cajun+southern"],
      ["Breakfast &amp; Brunch", "breakfast_brunch"],
      ["Buffets", "buffets"],
      ["Burgers", "burgers"],
      ["Chinese", "chinese"],
      ["Deli &amp; Sandwiches", "delis+sandwiches"],
      ["Diners", "diners"],
      ["Fast Food", "hotdogs+foodstands"],
      ["Italian", "italian+pizza"],
      ["Mexican", "mexican+tex-mex"],
      ["Pizza", "pizza"],
      ["Seafood", "seafood"],
      ["Steakhouses", "steak"],
      ["Sushi &amp; Japanese", "sushi+japanese"],
      ["Indian, Thai &amp; Viet", "indpak+thai+vietnamese"],
      ["Vegetarian &amp; Vegan", "vegetarian+vegan"],
      ["Other Asian", "asianfusion+burmese+cambodian+chinese+dimsum+filipino+himalayan+indonesian+japanese+malaysian+sushi+singaporean+mongolian+taiwanese"],
      ["Other European", "basque+belgian+british+creperies+fishnchips+french+german+hungarian+greek+italian+irish+korean+mediterranean+modern_european+polish+scandinavian"],
      ["Other Latino", "argentine+brazilian+caribbean+cuban+latin+mexican+portuguese+spanish+tapas"],
      ["Other Exotic", "ethiopian+fondue+hawaiian+kosher+raw_food+mideastern+gastropubs+halal+moroccan+pakistani+persian+russian+ukrainian+turkish"]
    ].map do |genre|
      id = genre.first.gsub(/[^a-z]+/i, '_').downcase
      content_tag "li" do
        check_box_tag(id, genre.last) + label_tag(id, genre.first)
      end
    end
    return content_tag "ul", ["\n", items.join("\n"), "\n"], :id => "categories"
  end

end
