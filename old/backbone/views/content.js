ContentView = Backbone.View.extend({
    tagName: "div",
    className: "content",
    template: "content",
    events: {
        //"mouseover .content-inner": "showActionButtons",
        //"mouseout .content-inner": "hideActionButtons",
        //"mouseenter .sections": "hideActionButtons",
        "click .content-button.add-button": "addNewSection", 
    },
    showActionButtons: function() {
        this.$(".content-button").show()
    },
    hideActionButtons: function() {
        this.$(".content-button").hide()
        return false // to stop the propagation so that it won't trigger the parent's
    },
    render: function() {
        this.renderTemplate()
        if (this.model.get("_editor")) {
        	this.makeEditable()
        	this.makeSortable()
        }
        this.update()
        return this
    },
    initialize: function() {
        this.sectionViews = {}
        this.el = $(this.el)
        this.model.bind('change', this.update, this)
        this.model.bind("update:sections", this.updateSections, this)
        this.model.bind("add:sections", this.addSections, this)
        this.model.bind("remove:sections", this.removeSections, this)
        this.model.bind('change:_editor', this.render, this)
        this.model.bind('save', this.saved, this)
        this.render()
    },
    addNewSection: function() {
        var new_section = {type: this.$(".add-section-type").val()}
        if (this.model.get("width"))
            new_section.width = this.model.get("width") 
        this.model.get('sections').create(new_section)
    },    
    updateSections: function(model, coll) {
        //alert('update sections')
    },
    addSections: function(model, coll) {
        this.sectionViews[model.cid] = new SectionView({model: model})
        // hack to make sure it's inserted in the right position (order)
        var found = false
        for (var i=0; i<coll.length; i++) {
        	if (found) {
        		if (this.sectionViews[coll.at(i).cid]) {
        			this.sectionViews[coll.at(i).cid].el.before(this.sectionViews[model.cid].el)
        			return
        		}
        	} else if (model.cid==coll.at(i).cid) {
        		found = true
        	}
        }
        // we didn't find something to insert it before, so append it to end
        this.$('.sections').append(this.sectionViews[model.cid].el)
    },
    removeSections: function(model, coll) {
        if (!this.sectionViews[model.cid] || !this.sectionViews[model.cid].el) return
        $(this.sectionViews[model.cid].el).fadeOut(300, function() { $(this).remove() })
        delete this.sectionViews[model.cid]
    },
    makeEditable: function() {
        var self = this
        this.$(".title").editable(function(new_value) {
            self.model.set({title: new_value}).save()
        }, {
            submit: "Save",
            cancel: "Cancel",
            event: "dblclick",
            cssclass: "jeditable",
            tooltip: "Double click to edit",
            onedit: function() {
                _.defer(function() { self.$(".jeditable button").addClass("btn").css("margin-left", 5) })
            }
        })
    },
    makeSortable: function() {
        var self = this
        this.$('.sections').sortable({
            update: function(event, ui) {
                // get the post-sort section order (as a list of id's) and save the new collection order 
                var new_order = self.$('.sections').sortable("toArray")
                self.model.get('sections').reorder(new_order)
                self.model.save()
            },
            opacity: 0.6,
            tolerance: "pointer",
            handle: ".drag-button"
        })
    },
    update: function() {
        this.$('.title').text(this.model.get("title"))
    },
    saved: function() {
        console.log("content saved")        
    }
})
