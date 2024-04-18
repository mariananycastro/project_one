class InsuredPersonSerializer < ActiveModel::Serializer
  attributes :name, :document, :email
end
