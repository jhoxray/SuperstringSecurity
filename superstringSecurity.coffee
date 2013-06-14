_tlog = TLog?.getLogger(TLog.LOGLEVEL_INFO)

SuperstringSecurity = @SuperstringSecurity or= {}

_.extend SuperstringSecurity,

  Roles:
    administrator:
      name: "Administrator"
      description: "Built-in role allowing all access within the context"

  # just a module name to pass to logs
  name: "SuperstringSecurity"
# convenience method for checking if currently logged in user is admin
  isAdmin: ->
    ret = false
    try
      u = Meteor.user()
      if u and (u.securityProfile.globalRole == Roles.administrator or u.securityProfile.globalRole == "admin") # TODO: remove last part which is for compatibility only!
        ret = true
    catch err
      # this is somewhat tricky as Meteor allows calls to either user() or userId() depending on context, we need to try both
      try
        u = Meteor.users().findOne Meteor.userId()
        if u and (u.securityProfile.globalRole == Roles.administrator or u.securityProfile.globalRole == "admin") # TODO: remove last part which is for compatibility only!
          ret = true
      catch err
        # tracing only last error
        _tlog.trace err, "Error while trying to check if current user is Administrator"
    _tlog.warn "Authorized current user as an administrator!" if ret
    ret


  sendResetPasswordEmail: (uid,email)->
    Meteor.call "ssSendResetPasswordEmail", uid, email

  createUser: (email, username, profile)->
    Meteor.call "ssCreateUser", email, username, profile

  deleteUser: (uid)->
    Meteor.call "ssDeleteUser", uid

  # very basic validation function
  isValidPassword: (val)->
    if val.length >= 6 then true else false




