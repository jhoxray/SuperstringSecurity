#http://localhost:3000/#/reset-password/wN8vzfWyF9g3xp2Pq
_tlog = TLog?.getLogger()
SuperstringSecurity = @SuperstringSecurity or= {}

# setting up a catch function for password reset functionality
Meteor.startup ->
  _tlog?.debug "Running Meteor Startup","SuperstringSecurity"
  if (Accounts._resetPasswordToken)
    Session.set 'resetPassword', Accounts._resetPasswordToken
    _tlog?.warn "Got a resetPassword token! " + Accounts._resetPasswordToken
    Meteor.flush()

_.extend Template.superstringSecurity,
  rendered: ->
    # checking if we have a password reset token in the session and showing a modal that gets a new password
    Meteor.autorun ->
      token = Session.get 'resetPassword'
      #_tlog.debug "Got a token from session: " + token
      return if not token?
      #Meteor.flush()
      $("#ssPasswordResetForm").modal('show')
      #Meteor.flush()

Template.superstringSecurity.events
  'click #ssBtnNewPassword':->
    password = _.trimInput $('#ssNewPassword').val()
    $("#ssPasswordResetForm").modal('hide')
    token = Session.get('resetPassword')
    Session.set 'resetPassword', null
    _tlog.debug "Submitting new password " + password + "token " + token
    #TODO: add action on invalid password
    if SuperstringSecurity.isValidPassword password
      Accounts.resetPassword token, password, (err)->
        if err
          _tlog.trace err, "Error while resetting password", "SuperstringSecurity"
        else
          _tlog.info "Password reset for the user " + Meteor.user()._id

