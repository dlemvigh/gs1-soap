
listeners = [];

@DSC =
  addListener : (callback) ->
    listeners.push callback
  clearListeners : () ->
    listeners = []
  removeListener : (callback) ->
    index = listeners.indexOf(callback)
    if index >= 0
      listeners.splice index, 1
  emit : (args) ->
    console.log 'emitter called'
    listeners.forEach (listener) -> listener(args)


service =
  DataSourceOperationsCallbackService:
    wsHttpEndpoint:
      ReceiveCatalogueItemConfirmation: (args) ->
        logger.info 'ReceiveCatalogueItemConfirmation', {args}
        @DSC.emit(args)
        args

Meteor.startup () ->
  wsdl = Assets.getText Meteor.settings.wsdlPath + 'DataSourceOperationsCallbackService.Single.wsdl'
  Soap.listen "/soapDSC", service, wsdl
  logger.info 'DataSourceOperationsCallbackService listener started'
