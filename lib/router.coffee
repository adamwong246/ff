FlowRouter.route '/', action: ->
  BlazeLayout.render 'layout', content: 'main'
FlowRouter.route '/users', action: ->
  BlazeLayout.render 'layout', content: 'users'
FlowRouter.route '/relations', action: ->
  BlazeLayout.render 'layout', content: 'relations'
FlowRouter.route '/relation/:_id', action: (params) ->
  BlazeLayout.render 'layout', content: 'relationPage'
FlowRouter.route '/badges', action: ->
  BlazeLayout.render 'layout', content: 'badges'
FlowRouter.route '/patches', action: ->
  BlazeLayout.render 'layout', content: 'patches'
FlowRouter.route '/profile', action: ->
  BlazeLayout.render 'layout', content: 'profile'
