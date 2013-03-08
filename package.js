try {
Package.describe({
    summary: "Security framework for multi-tenant / corporate environments"
});

Package.on_use(function (api) {
    api.use(['coffeescript', 'bootstrap', 'underscore','templating','less'], 'client');

    api.add_files('superstringSecurity.coffee',['client','server']);
    api.add_files('server/core.coffee','server');
    api.add_files('client/core.coffee','client');
    api.add_files('client/superstringSecurity.html','client');

});
}
catch(err) {
    console.log(err.message);
}
