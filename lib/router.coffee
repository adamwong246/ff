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
FlowRouter.route '/badge/:_id', action: ->
  BlazeLayout.render 'layout', content: 'badgePage'
FlowRouter.route '/patches', action: ->
  BlazeLayout.render 'layout', content: 'patches'
FlowRouter.route '/patch/:_id', action: ->
  BlazeLayout.render 'layout', content: 'patchPage'
FlowRouter.route '/user/:_id', action: ->
  BlazeLayout.render 'layout', content: 'profile'
