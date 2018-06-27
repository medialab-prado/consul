class Admin::ProposalDashboard::ActionsController < Admin::ProposalDashboard::BaseController
  helper_method :proposal_dashboard_action, :resource

  def index
    @proposal_dashboard_actions = ProposalDashboardAction.all
  end

  def new
    @proposal_dashboard_action = ProposalDashboardAction.new(
      active: true,
      day_offset: 0,
      required_supports: 0,
      request_to_administrators: true,
      action_type: 'proposed_action'
    )
  end

  def create
    @proposal_dashboard_action = ProposalDashboardAction.new(proposal_dashboard_action_params)
    if @proposal_dashboard_action.save
      redirect_to admin_proposal_dashboard_actions_path, notice: t('admin.proposal_dashboard_actions.create.notice')
    else
      render :new
    end
  end

  def edit; end
  
  def update
    if proposal_dashboard_action.update(proposal_dashboard_action_params)
      redirect_to admin_proposal_dashboard_actions_path
    else
      render :edit
    end
  end

  def destroy
    if proposal_dashboard_action.destroy
      flash[:notice] = t('admin.proposal_dashboard_actions.delete.success')
    else
      flash[:error] = proposal_dashboard_action.errors.full_messages.join(',')
    end

    redirect_to admin_proposal_dashboard_actions_path
  end

  private

  def resource
    @proposal_dashboard_action
  end

  def proposal_dashboard_action_params
    params
      .require(:proposal_dashboard_action)
      .permit(:title, :description, :link, :request_to_administrators, :day_offset, :required_supports, :order, :active, :action_type)
  end


  def proposal_dashboard_action
    @proposal_dashboard_action ||= ProposalDashboardAction.find(params[:id])
  end
end