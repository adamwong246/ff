user_IdOfPage = -> FlowRouter.getParam("_id")
userOfPage = -> Meteor.users.findOne(user_IdOfPage())

Template.profile.onCreated ->
  # We can use the `ready` callback to interact with the map API once the map is ready.
  GoogleMaps.ready 'exampleMap', (map) ->
    # Add a marker to the map once it's ready
    marker = new (google.maps.Marker)(
      position: map.options.center
      map: map.instance)

Template.profile.helpers
  canEdit: ->
    user_IdOfPage() == Meteor.userId()
  user: ->
    userOfPage()
  userProfileImage: ->
    UserImages.findOne(userOfPage().profile.picture)
  email: ->
    userOfPage().emails[0].address
  profileMapOptions: ->
    if GoogleMaps.loaded() && @profile.location
      location = @profile.location.split(',')
      # console.log location
      center: new google.maps.LatLng(Number(location[0]), Number(location[1])),
      zoom: 5
  groups: ->
    Groups.find
      members:
        '$elemMatch':
          _id: user_IdOfPage()
  groupLink: ->
    '/group/' + @_id
  badges: ->
    Badges.find
      userIds:
        '$in': [ user_IdOfPage() ]
  badgeImage: ->
    BadgeImages.findOne(@picture)
  pinnableMessages: ->
    Messages.find
      $and: [
        {claimedPatch: {$exists: true}},
        {createdBy: user_IdOfPage()}
      ]
  myPatches: ->
    Patches.find
      _id:
        $in: _.map Messages.find(
          {$and: [
            {claimedPatch: {$exists: true}},
            {createdBy: user_IdOfPage()}
          ]},
          {_id: 1}
        ).fetch(), (k) -> k.claimedPatch
  patchImage: ->
    PatchImages.findOne(@picture)
