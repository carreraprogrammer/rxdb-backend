module Types
  class TodoInputPushType < Types::BaseInputObject
    argument :assumedMasterState, Types::TodoStateInputType, required: false
    argument :newDocumentState, Types::TodoStateInputType, required: true
  end
end