
namespace :populate do
  desc "create the custom option to the companies"
  task :page_layouts => :environment do
    company_id = ENV['COMPANY_ID']
    
    if company_id.blank?
      puts "❌ Error: Please provide a COMPANY_ID (e.g., rake populate:page_layouts COMPANY_ID=1)"
      exit
    end

    company = Company.find_by(id: company_id)
    
    if company.nil?
      puts "❌ Error: Company with ID #{company_id} not found."
      exit
    end

    puts "🛠️  Populating layouts for: #{company.name}..."

    company.page_layouts.draft.destroy_all
    puts "🗑️  Cleaned up existing index layouts."

    # 2. Create the Index Page Layout
    index_page = company.page_layouts.create!(
      path: "/",
      page_type: :system,
      meta_title: "Welcome to our store. Browse our latest arrivals and categories.",
      version: :draft # Or :draft depending on your workflow
    )

    blocks = [

    ]

    blocks.each do |block_data|
      index_page.page_components.create!(
        component_type: block_data[:type],
        position: block_data[:pos],
        config: block_data[:config]
      )
      
      puts "✅ Added block: #{block_data[:type]} at position #{block_data[:pos]}"
    end

    puts "✨ Successfully populated index page for #{company.name}!"
  end
end
