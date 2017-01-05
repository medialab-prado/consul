require 'rails_helper'

feature 'Legislation Draft Versions' do
  let(:user) { create(:user) }
  let(:administrator) do
    create(:administrator, user: user)
    user
  end

  context "See draft text page" do
    before(:each) do
      @process = create(:legislation_process)
      @draft_version_1 = create(:legislation_draft_version, process: @process, title: "Version 1", body: "Body of the first version", status: "published")
      @draft_version_2 = create(:legislation_draft_version, process: @process, title: "Version 2", body: "Body of the second version", status: "published")
      @draft_version_3 = create(:legislation_draft_version, process: @process, title: "Version 3", body: "Body of the third version", status: "draft")
    end

    it "shows the text body for this version" do
      visit legislation_process_draft_version_path(@process, @draft_version_1)

      expect(page).to have_content("Body of the first version")

      within('select#draft_version_id') do
        expect(page).to have_content("Version 1")
        expect(page).to have_content("Version 2")
        expect(page).to_not have_content("Version 3")
      end
    end

    it "shows an unpublished version to admins" do
      login_as(administrator)

      visit legislation_process_draft_version_path(@process, @draft_version_3)

      expect(page).to have_content("Body of the third version")

      within('select#draft_version_id') do
        expect(page).to have_content("Version 1")
        expect(page).to have_content("Version 2")
        expect(page).to have_content("Version 3 *")
      end
    end

    it "switches to another version without js" do
      visit legislation_process_draft_version_path(@process, @draft_version_1)
      expect(page).to have_content("Body of the first version")

      select("Version 2")
      click_button "see"

      expect(page).to_not have_content("Body of the first version")
      expect(page).to have_content("Body of the second version")
    end

    it "switches to another version with js", :js do
      visit legislation_process_draft_version_path(@process, @draft_version_1)
      expect(page).to have_content("Body of the first version")

      select("Version 2")

      expect(page).to_not have_content("Body of the first version")
      expect(page).to have_content("Body of the second version")
    end
  end

  context "See changes page" do
    before(:each) do
      @process = create(:legislation_process)
      @draft_version_1 = create(:legislation_draft_version, process: @process, title: "Version 1", body: "Body of the first version", changelog: "Changes for first version", status: "published")
      @draft_version_2 = create(:legislation_draft_version, process: @process, title: "Version 2", body: "Body of the second version", changelog: "Changes for second version", status: "published")
      @draft_version_3 = create(:legislation_draft_version, process: @process, title: "Version 3", body: "Body of the third version", changelog: "Changes for third version", status: "draft")
    end

    it "shows the changes for this version" do
      visit legislation_process_draft_version_changes_path(@process, @draft_version_1)

      expect(page).to have_content("Changes for first version")

      within('select#draft_version_id') do
        expect(page).to have_content("Version 1")
        expect(page).to have_content("Version 2")
        expect(page).to_not have_content("Version 3")
      end
    end

    it "shows an unpublished version to admins" do
      login_as(administrator)

      visit legislation_process_draft_version_changes_path(@process, @draft_version_3)

      expect(page).to have_content("Changes for third version")

      within('select#draft_version_id') do
        expect(page).to have_content("Version 1")
        expect(page).to have_content("Version 2")
        expect(page).to have_content("Version 3 *")
      end
    end

    it "switches to another version without js" do
      visit legislation_process_draft_version_changes_path(@process, @draft_version_1)
      expect(page).to have_content("Changes for first version")

      select("Version 2")
      click_button "see"

      expect(page).to_not have_content("Changes for first version")
      expect(page).to have_content("Changes for second version")
    end

    it "switches to another version with js", :js do
      visit legislation_process_draft_version_changes_path(@process, @draft_version_1)
      expect(page).to have_content("Changes for first version")

      select("Version 2")

      expect(page).to_not have_content("Changes for first version")
      expect(page).to have_content("Changes for second version")
    end
  end

  context 'Annotations', :js do
    let(:user) { create(:user) }
    background { login_as user }

    scenario 'Create' do
      draft_version = create(:legislation_draft_version, :published, body: Faker::Lorem.paragraph)

      visit legislation_process_draft_version_path(draft_version.process, draft_version)

      page.find(:css, ".legislation-annotatable").double_click
      page.find(:css, ".annotator-adder button").click
      fill_in 'annotator-field-0', with: 'this is my annotation'
      page.find(:css, ".annotator-controls a[href='#save']").click

      expect(page).to have_css ".annotator-hl"
      first(:css, ".annotator-hl").click
      expect(page).to have_content "this is my annotation"

      visit legislation_process_draft_version_path(draft_version.process, draft_version)

      expect(page).to have_css ".annotator-hl"
      first(:css, ".annotator-hl").click
      expect(page).to have_content "this is my annotation"
    end

    scenario 'Search' do
      draft_version = create(:legislation_draft_version, :published, body: Faker::Lorem.paragraph)
      annotation1 = create(:legislation_annotation, draft_version: draft_version, text: "my annotation",       ranges: [{"start"=>"/p[1]", "startOffset"=>5, "end"=>"/p[1]", "endOffset"=>10}])
      annotation2 = create(:legislation_annotation, draft_version: draft_version, text: "my other annotation", ranges: [{"start"=>"/p[1]", "startOffset"=>12, "end"=>"/p[1]", "endOffset"=>19}])

      visit legislation_process_draft_version_path(draft_version.process, draft_version)

      expect(page).to have_css ".annotator-hl"
      first(:css, ".annotator-hl").click
      expect(page).to have_content "my annotation"

      all(".annotator-hl")[1].click
      expect(page).to have_content "my other annotation"
    end
  end

end