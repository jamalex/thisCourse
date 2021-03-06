define ["cs!base/models", "cs!course/models", "cs!auth/models", "cs!./router", "cs!userstatus/models"], \
        (basemodels, coursemodels, authmodels, router, userstatusmodels) ->
    
    class AppModel extends basemodels.LazyModel
                
        relations: ->
            course:
                model: coursemodels.CourseModel
                includeInJSON: false
            tabs:
                collection: TabCollection
                includeInJSON: true
            user:
                model: authmodels.UserModel

        initialize: (options={}) ->
            @router = new router.BaseRouter
                root_url: @get("root_url")
                app: @

        navigate: (url, options) =>
            if not url then return
            if url instanceof Function then url = url()
            link = $("<a href='" + url + "'>")[0]
            pathname = link.pathname.replace(/^\/+/,"")
            if pathname.slice(-1) isnt "/" then pathname += "/"
            url = "/" + pathname + link.search # hack (?) to resolve relative paths (e.g. "..")
            root = @get("root_url")
            if url[0...root.length]==root then url = url[root.length...] # trim off the leading root url, if present
            @set (url: url), (silent:true) # silent so that we don't trigger twice (see next)
            @trigger "change:url", @, url, options # hack to make pushstate work well with back buttons

        start: ->
            @router.start()
            Backbone.history.start pushState: true, root: @get("root_url")

        updateUserStatus: (data) =>
            @get('userstatus').clear silent: true
            @get('userstatus').set data.userstatus
            @trigger "nuggetAnalyticsChanged"

    class TabModel extends basemodels.LazyModel
        
        initialize: ->
            if @get("slug").slice?(-1) is "/"
                @set slug: @get("slug").slice(0,-1)
        
    class TabCollection extends basemodels.LazyCollection
        model: TabModel
        
        comparator: => @get("priority")

    AppModel: AppModel