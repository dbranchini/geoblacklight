require 'spec_helper'

feature 'Download layer' do
  scenario 'clicking initial shapefile download button should trigger download', js: true do
    expect_any_instance_of(ShapefileDownload).to receive(:get).and_return('mit-us-ma-e25zcta5dct-2000-shapefile.zip')
    visit catalog_path('mit-us-ma-e25zcta5dct-2000')
    find('a', text: 'Download Shapefile').click
    expect(page).to have_css('a', text: 'Your file mit-us-ma-e25zcta5dct-2000-shapefile.zip is ready for download')
  end
  scenario 'clicking kmz download button should trigger download', js: true do
    expect_any_instance_of(KmzDownload).to receive(:get).and_return('mit-us-ma-e25zcta5dct-2000-kmz.kmz')
    visit catalog_path('mit-us-ma-e25zcta5dct-2000')
    find('button.download-dropdown-toggle').click
    find('a', text: 'Download KMZ').click
    expect(page).to have_css('a', text: 'Your file mit-us-ma-e25zcta5dct-2000-kmz.kmz is ready for download')
  end
  scenario 'options should be available under toggle' do
    visit catalog_path('mit-us-ma-e25zcta5dct-2000')
    find('button.download-dropdown-toggle').click
    expect(page).to have_css('li a', text: 'Download Shapefile')
    expect(page).to have_css('li a', text: 'Download KMZ')
  end
  scenario 'restricted layer should not have download available to non logged in user' do
    visit catalog_path('stanford-cg357zz0321')
    expect(page).to have_css 'a', text: 'Login to view and download'
    expect(page).to_not have_css 'button', text: 'Download Shapefile'
  end
  scenario 'restricted layer should have download available to logged in user' do
    sign_in
    visit catalog_path('stanford-cg357zz0321')
    expect(page).to_not have_css 'a', text: 'Login to view and download'
    expect(page).to have_css 'a', text: 'Download Shapefile'
    expect(page).to have_css 'button.download-dropdown-toggle'
  end
  scenario 'layer with direct download and wms/wfs should include all download types' do
    sign_in
    visit catalog_path('stanford-cg357zz0321')
    expect(page).to have_css 'a', text: 'Download Shapefile'
    find('button.download-dropdown-toggle').click
    expect(page).to have_css 'li.dropdown-header', text: 'Original'
    expect(page).to have_css 'li.dropdown-header', text: 'Generated'
    expect(page).to have_css 'li a', text: 'Download Shapefile'
    expect(page).to have_css 'li a', text: 'Download KMZ'
  end
  scenario 'clicking GeoTIFF button for Harvard layer should show email form', js: true do
    visit catalog_path('harvard-g7064-s2-1834-k3')
    find('a', text: 'Download GeoTIFF').click
    expect(page).to have_css('#hglRequest')
  end
  scenario 'submitting email form should trigger HGL request', js: true do
    expect_any_instance_of(HglDownload).to receive(:get).and_return('success')
    visit catalog_path('harvard-g7064-s2-1834-k3')
    find('a', text: 'Download GeoTIFF').click
    within '#hglRequest' do
      fill_in('Email', with: 'foo@example.com')
      click_button('Request')
    end
    expect(page).to have_content('You should receive an email when your download is ready')
  end
end
