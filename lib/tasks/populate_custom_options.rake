
namespace :populate do
  desc "create the custom option to the companies"
  task :custom_options => :environment do
    ItemConfiguration.destroy_all
    puts "Creating ProductCardStyle...."

    ItemConfiguration.create(
      name: "ProductCardStyle",
      description: "lets choose an product card style",
      options: [ {value: "minimal"}, {value: "premium"}, {value: "compact"}, {value: "detailed"}, {value: "profile"}, {value: "minimal2"} ]
    )

    puts "Creating ProductDetailStyle...."
    ItemConfiguration.create(
      name: "ProductDetailStyle",
      description: "lets choose an product detail style",
      options: [ {value: "default"}, {value: "premium"}]
    )

    puts "Creating productImagesConfiguration...."
    ItemConfiguration.create(
      name: "productImagesConfiguration",
      description: "lets choose an product images configuration",
      options: [ {value: "default"}, {value: "imageGridGallery"} ]
    )
  end
end
