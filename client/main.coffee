###
@description Set default session values for token and userId
###
Session.setDefault 'UserStatusToken', null
Session.setDefault 'UserStatusUserId', null

###
@description Re-run condition each time Session's value is changed
###
Tracker.autorun =>
  # @description Store userId into "UserStatusUserId" Session and get token from server method
  if Meteor.userId() and !Session.get 'UserStatusToken'
    Session.set 'UserStatusUserId', Meteor.userId()
    Meteor.call 'UserStatusGetToken', Session.get('UserStatusUserId'), (err, data) ->
      throw new Meteor.Error 'Error on calling "UserStatusGetSecure"', err if err
      Session.set 'UserStatusToken', data


  # @description If we are already have userId and token, then update user status to 
  else if Meteor.userId() and Session.get 'UserStatusToken'
    Meteor.call 'UserStatusSet', Session.get('UserStatusUserId'), Session.get('UserStatusToken'), true, (err) ->
      throw new Meteor.Error 'Error on calling "UserStatusSet"', err if err

  # @description If we are already have userId and token, but user isn't logged in, then update user status to 
  else if !Meteor.userId() and Session.get('UserStatusUserId') and Session.get 'UserStatusToken'
    Meteor.call 'UserStatusSet', Session.get('UserStatusUserId'), Session.get('UserStatusToken'), false, (err) ->
      throw new Meteor.Error 'Error on calling "UserStatusSet"', err if err