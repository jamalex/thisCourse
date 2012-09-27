LectureView = Backbone.TopView.extend({
    className: "lecture",
    template: "lecture",
    render: function() {
        this.renderTemplate()
        this.renderTopView()
        this.renderPageView()
        return this
    },
    renderTopView: _.debounce(function() {
        this.$(".lecture-top").html("").append(this.topView.render().el)
    }, 50),
    renderPageView: function() {
        this.$(".lecture-page").html("").append(this.pageView.el)
    },
    events: {
        "click .lecture-top .edit-button": "edit"
    },
    initialize: function() {
        var self = this
        this.el = $(this.el)
        this.model.bind('change:page', this.pageChanged, this)
        this.model.bind('change:_id', this.changeId, this)
        this.model.bind('change:_editor', this.renderTopView, this)
        this.model.bind('change:title', this.titleChange, this)
        this.model.bind('save', this.saved, this)
        this.topView = new LectureTopView({model: this.model})
        this.pageView = new PageView({model: this.model.get("page"), url: base_url + "lectures/" + this.model.id})
        this.model.get("page").fetch()
        this.render()
        this.subrouter.route("pages/:page", "pages", function(page) { self.pageView.showSubpage(page) })
    },
    pageChanged: function() {
        //console.log("page changed")
        
    },
    close: function() {
        this.el.remove()
    },
    titleChange: function() {
        // keep track of the title having changed so we know to save the parent  
        this.titleChanged = true
    },
    edit: function(){
        this.topEditView = new LectureTopEditView({model: this.model, parent: this})
        this.$(".lecture-top").empty().append(this.topEditView.el)
    },
    saved: function() {
        // save the parent too (so it stores the title), but only if the title has changed
        //console.log("lecture saved")
        if (this.titleChanged) {
            this.saveParent()
            delete this.titleChanged
        }        
    },
    changeId: function () {
        this.saveParent()
        this.el.attr('id', this.model.id)
    },
    saveParent: function() {
        //alert('saving parent')
        this.model.get('page').save()
    }
})

LectureTopView = Backbone.View.extend({
    tagName: "div",
    className: "lecture-top",
    template: "lecture-top",
    events: {
        //"mouseover .content-inner": "showActionButtons",
        //"mouseout .content-inner": "hideActionButtons",
        //"mouseenter .sections": "hideActionButtons",
    },
    render: function() {
        this.renderTemplate()
        //this.pageView.render().el.after(this.el)
        return this
    },
    initialize: function() {
        this.el = $(this.el)
        this.model.bind('change:title', this.render, this)
        this.model.bind('change:description', this.render, this)
        //this.model.fetch()
        //this.render()
    },
    pageChanged: function() {
        console.log("page changed")
        this.pageView = new PageView({model: this.model.get("page")})
    },
    close: function() {
        this.el.remove()
    },
    titleChange: function() {
        // keep track of the title having changed so we know to save the parent  
        this.titleChanged = true
    },
    changeId: function () {
        this.saveParent()
        this.el.attr('id', this.model.id)
    }
})

LectureListView = Backbone.View.extend({
    tagName: "div",
    template: "lecture-list",
    events: {
        "click .add-button": "addNewLecture"
    },
    render: function() {
    	var self = this
    	this.collection._editor = app.get("_editor") // TODO: find a better solution here, obviously
        this.renderTemplate()
        this.$("li").each(function(ind, el) {
        	make_link($("a.open", el), "lectures/" + $(el).attr("id"))
        	$("a.delete", el).click(function() { self.deleteLecture($(el).attr("id")) })
        })
        if (this.collection._editor)
        	this.makeSortable()
        return this
    },
    initialize: function() {
        this.el = $(this.el)
        this.collection.bind("change", this.render, this)
        this.collection.bind("remove", this.render, this)
        this.collection.bind("add", this.render, this)
        app.bind("change:_editor", this.render, this)
        this.render()
    },
    addNewLecture: function() {
        var self = this
        dialog_request_response("Please enter a title:", function(title) {
            var page = new Page
            page.save().success(function() {
                var new_lecture = new Lecture({title: title, page: page})
                app.course.get('lectures').add(new_lecture)
                new_lecture.save().success(function() { app.course.save() })
            })
        })
        return false
    },
    deleteLecture: function(id) {
    	var self = this
    	delete_confirmation(this.collection.get(id), "lecture", function() {
	    	self.collection.remove(self.collection.get(id))
	    	app.course.save()    		
    	})
    },
    makeSortable: function() {
        var self = this
        this.$('ul').sortable({
            update: function(event, ui) {
                // get the post-sort order (as a list of id's) and save the new collection order 
                var new_order = self.$('ul').sortable("toArray")
                self.collection.reorder(new_order)
                app.course.save()
            },
            opacity: 0.6,
            tolerance: "pointer"
        })
    },
    close: function() {
        this.el.remove()
        this.collection.unbind("add", this.render, this)
    }
})

DateListView = Backbone.View.extend({
    tagName: "div",
    className: "date-list",
    template: "date-list",
    render: function() {
    	var self = this
        this.renderTemplate({data: {dates: this.dates}})
        this.$(".scheduled-date").datepicker({
        	onSelect: function(date) {
        		self.dates.push(new Date(date))
        		self.sortDates()
        		self.setDates(self.dates)
        	},
        	showOn: "button",
			buttonText: "Schedule new date..."
        })
        return this
    },
    events: {
        "click .remove-date": "remove"
    },
    remove: function(ev) {
    	this.dates.splice($(ev.srcElement).attr("index"), 1)
    	window.d = this.dates
		this.setDates(this.dates)
    },
    setDates: function(dates) {
    	var data = {}
    	data[this.options.date_attr] = dates
    	this.model.set(data)
    },
    compareDates: function(date1, date2) {
		if (date1 > date2) return 1
		if (date1 < date2) return -1
		return 0
	},
	sortDates: function() {
		this.dates.sort(this.compareDates)
	},
    datesChanged: function() {
        this.dates = this.model.getDate(this.options.date_attr)
        if (!(this.dates instanceof Array)) this.dates = [this.dates]
		this.sortDates()
		this.render()
    },
    initialize: function() {
        this.el = $(this.el)
        //this.dates = [new Date, new Date, new Date]
        //this.remove({srcElement: "body"})
		this.model.bind("change:" + this.options.date_attr, this.datesChanged, this)
		this.datesChanged()
    }
}) 

LectureTopEditView = Backbone.View.extend({
    tagName: "div",
    className: "lecture-edit",
    template: "lecture-edit",
    render: function() {
    	var self = this
        this.renderTemplate()
        Backbone.ModelBinding.bind(this)
        this.enablePlaceholders()
        
        //console.log("rendering top edit view")
        //this.date_list_view = new DateListView({model: this.model, date_attr: "scheduled", el: this.$(".scheduled-dates")})
        this.date_list_view = new DateListView({model: this.model, date_attr: "scheduled"})
        _.defer(function() {
        	$(".scheduled-dates").append(self.date_list_view.el) // TODO: why doesn't it work if not deferred or if scoped?
        })
        
        
        //var scheduled = this.model.getDate("scheduled")
        // if (scheduled)
        	// this.$(".scheduled-date").val((scheduled.getMonth()+1) + "/" + scheduled.getDate() + "/" + scheduled.getFullYear())
        // this.$(".scheduled-date").datepicker({
        	// onSelect: function(date) {
        		// $(".scheduled-date:visible").val(date)
        	// }
        // })
        return this
    },
    events: {
        "click button.save": "save",
        "click button.cancel": "cancel"
    },
    base: ItemEditInlineView,
    save: function() {
    	// var scheduled = $(".scheduled-date:visible").val() || null // TODO: why does scoping this make it not work?
    	// if (scheduled) scheduled = new Date(scheduled)
    	// this.model.set({scheduled: scheduled})
        ItemEditInlineView.prototype.save.apply(this)
    },
    saved: function() {
        ItemEditInlineView.prototype.saved.apply(this)
        this.model.get("course").save()
    },
    cancel: ItemEditInlineView.prototype.cancel,
    restore: ItemEditInlineView.prototype.cancel,
    close: function() {
        this.options.parent.renderTopView()
        Backbone.ModelBinding.unbind(this)
    },
    initialize: function() {
        this.el = $(this.el)
        this.memento = new Backbone.Memento(this.model)
        this.memento.store()
        this.render()
    }
})