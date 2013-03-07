_tlog = TLog?.getLogger()

# Definitions of sensitive server operations
Meteor.methods
  ssDeleteUser: (uid)->
    if @userId
      user = Meteor.users.findOne @userId
      try
        if user.securityProfile.globalRole == "admin"
          _tlog?.warn "Deleting user: " + uid, "SuperstringSecurity"
          Meteor.users.remove uid
          _tlog?.info "DELETED user: " + uid, "SuperstringSecurity"
        else
          _tlog?.error "Unauthorized user userId: " + @userId + " tried to delete a user: " + uid, "SuperstringSecurity"
      catch err
        _tlog?.trace err, "Error while trying to delete a user: " + uid, "SuperstringSecurity"
    else
      _tlog?.error "Anonymous user tried to delete a user: " + uid, "SuperstringSecurity"


  ssCreateUser: (email, username, profile)->
    if @userId
      user = Meteor.users.findOne @userId
      try
        if user.securityProfile.globalRole == "admin"
          _tlog?.warn "Creating new user: " + email, "SuperstringSecurity"
          uid = Accounts.createUser {username: username, email: email, profile: profile}
          Meteor.users.update uid, $set:
            securityProfile:
              globalRole: "user"
          _tlog?.info "Created new user: " + uid, "SuperstringSecurity"
        else
          _tlog?.error "Unauthorized user userId: " + @userId + " tried to create a new user: " + email, "SuperstringSecurity"
      catch err
        _tlog?.trace err, "Error while trying to create a new user", "SuperstringSecurity"
    else
      _tlog?.error "Anonymous user tried to create a new user: " + email, "SuperstringSecurity"

  ssSendResetPasswordEmail: (uid, email)->
    if @userId
      user = Meteor.users.findOne @userId
      try
        if user.securityProfile.globalRole == "admin" or @userId == uid
          _tlog?.warn "Sending password reset email for userId: " + uid, "SuperstringSecurity"
          if email?
            Accounts.sendResetPasswordEmail uid, email
          else
            Accounts.sendResetPasswordEmail uid
        else
          _tlog?.error "Unauthorized user userId: " + @userId + " tried to reset a password for userId: " + uid, "SuperstringSecurity"
      catch err
        _tlog?.trace err, "Error while trying to send password reset email", "SuperstringSecurity"
    else
      _tlog?.error "Anonimous user tried to reset a password for userId: " + uid, "SuperstringSecurity"
