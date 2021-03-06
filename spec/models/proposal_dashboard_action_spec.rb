require 'rails_helper'

describe ProposalDashboardAction do
  subject do 
    build :proposal_dashboard_action, 
          title: title, 
          description: description,
          day_offset: day_offset,
          required_supports: required_supports,
          request_to_administrators: request_to_administrators,
          action_type: action_type
  end

  let(:title) { Faker::Lorem.sentence }
  let(:description) { Faker::Lorem.sentence }
  let(:day_offset) { 0 }
  let(:required_supports) { 0 }
  let(:request_to_administrators) { true }
  let(:action_type) { 'resource' }

  it { should be_valid }

  context 'when validating title' do
    context 'and title is blank' do
      let(:title) { nil }

      it { should_not be_valid }
    end

    context 'and title is very short' do
      let(:title) { 'abc' }

      it { should_not be_valid }
    end

    context 'and title is very long' do
      let(:title) { 'a' * 81 }

      it { should_not be_valid }
    end
  end

  context 'when validating day_offset' do
    context 'and day_offset is nil' do
      let(:day_offset) { nil }

      it { should_not be_valid }
    end

    context 'and day_offset is negative' do
      let(:day_offset) { -1 }

      it { should_not be_valid }
    end

    context 'and day_offset is not an integer' do
      let(:day_offset) { 1.23 }

      it { should_not be_valid }
    end
  end

  context 'when validating required_supports' do
    context 'and required_supports is nil' do
      let(:required_supports) { nil }

      it { should_not be_valid }
    end

    context 'and required_supports is negative' do
      let(:required_supports) { -1 }

      it { should_not be_valid }
    end

    context 'and required_supports is not an integer' do
      let(:required_supports) { 1.23 }

      it { should_not be_valid }
    end
  end

  context 'when action type is nil' do
    let(:action_type) { nil }
    
    it { should_not be_valid }
  end
end

