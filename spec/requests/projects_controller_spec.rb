require 'rails_helper'

RSpec.describe ProjectsController, type: :request do
  let(:tenant) { create(:tenant) }
  let(:admin)  { create(:user, password: "password123") }
  let(:staff)  { create(:user, password: "password123") }
  let(:client) { create(:user, password: "password123") }
  let!(:project) { create(:project, tenant: tenant, name: "Test Project") }

  before do
    create(:membership, user: admin, tenant: tenant, role: "admin")
    create(:membership, user: staff, tenant: tenant, role: "staff")
    create(:membership, user: client, tenant: tenant, role: "client")
  end

  def sign_in_with_tenant(user)
    sign_in user
    allow_any_instance_of(ApplicationController).to receive(:current_tenant).and_return(tenant)
  end

  describe "as staff" do
    before { sign_in_with_tenant(staff) }

    it "can create a project" do
      expect {
        post projects_path, params: { project: { name: "Staff Project", status: "New" } }
      }.to change(Project, :count).by(1)
    end

    it "can change project status (New → In Progress)" do
      patch change_status_project_path(project), params: { to_status: "In Progress", reason: "Started" }
      expect(project.reload.status).to eq("In Progress")
    end

    it "can change project status (In Progress → Done)" do
      project.update!(status: "In Progress")
      patch change_status_project_path(project), params: { to_status: "Done", reason: "Completed" }
      expect(project.reload.status).to eq("Done")
    end

    it "cannot archive a project" do
      patch change_status_project_path(project), params: { to_status: "Archived", reason: "Locked" }
      expect(response).to redirect_to(project_path(project))
      expect(flash[:alert]).to match(/only admins can archive/i)
      expect(project.reload.status).not_to eq("Archived")
    end

    it "cannot delete a project" do
      delete project_path(project)
      expect(response).to redirect_to(projects_path)
      expect(flash[:alert]).to match(/You are not authorised to perform this action/i)
      expect(Project.exists?(project.id)).to be true
    end
  end

  describe "as client" do
    before { sign_in_with_tenant(client) }

    it "can view projects" do
      get projects_path
      expect(response.body).to include("Test Project")
    end

    it "cannot change project status" do
      patch change_status_project_path(project), params: { to_status: "Done", reason: "Done by client" }
      expect(response).to redirect_to(project_path(project))
      expect(flash[:alert]).to match(/not authorised/i)
      expect(project.reload.status).not_to eq("Done")
    end

    it "cannot delete a project" do
      delete project_path(project)
      expect(response).to redirect_to(projects_path)
      expect(flash[:alert]).to match(/You are not authorised to perform this action/i)
      expect(Project.exists?(project.id)).to be true
    end
  end

  describe "as admin" do
    before { sign_in_with_tenant(admin) }

    it "can delete a project" do
      expect {
        delete project_path(project)
      }.to change(Project, :count).by(-1)
    end

    it "can archive a project" do
      patch change_status_project_path(project), params: { to_status: "Archived", reason: "Wrapped up" }
      expect(project.reload.status).to eq("Archived")
    end
  end

  describe "tenant isolation" do
    let(:other_tenant) { create(:tenant) }
    let!(:other_project) { create(:project, tenant: other_tenant, name: "Hacked") }

    before { sign_in_with_tenant(admin) }

    it "returns 404 when accessing another tenant's project" do
      get project_path(other_project)
      expect(response).to have_http_status(:not_found)
    end
  end
end
