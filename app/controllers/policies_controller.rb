# frozen_string_literal: true

class PoliciesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def show
    policy = Policy.find(params[:id])

    render json: policy,
      except: [:created_at, :updated_at],
      include: {
        insured_person: { only: [:name, :document] },
        vehicle: { only: [:brand, :vehicle_model, :year, :license_plate] }
      }
  end

  def record_not_found
    render body: nil, status: :not_found
  end
end
