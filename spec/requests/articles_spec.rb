# frozen_string_literal: true

require "spec_helper"

RSpec.describe "Articles management", type: :request, order: :defined do
  let(:valid_params) { { article: { title: "Doh", content: FFaker::Lorem.sentence } } }

  context "versioning disabled" do
    specify { expect(PaperTrail).not_to be_enabled }
  end

  with_versioning do
    let(:article) { Article.last }

    context "`current_user` method returns a `String`" do
      it "sets that value as the `whodunnit`" do
        expect {
          post articles_path, params_wrapper(valid_params)
        }.to change(PaperTrail::Version, :count).by(1)
        expect(article.title).to eq("Doh")
        expect(article.versions.last.whodunnit).to eq("foobar")
      end
    end
  end
end
