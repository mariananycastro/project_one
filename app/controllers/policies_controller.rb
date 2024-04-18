# frozen_string_literal: true

class PoliciesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    policies = Policy.all

    render json: policies, each_serializer: PolicySerializer
  end

  def insured_person_by_email
    policies = Policy.by_email(params[:email])

    render json: policies, each_serializer: PolicySerializer
  end
  
  def show
    policy = Policy.find(params[:id])

    render json: policy, serializer: PolicySerializer
  end

  private

  def record_not_found
    render body: nil, status: :not_found
  end
end
