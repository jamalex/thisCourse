(function() {

    var type = "ITEMTYPE"
    
    ItemViews[type] = ItemView.extend({
        base: ItemView.prototype,
        render: function() {
            var self = this
            this.base.render.apply(this, arguments)
            return this
        },
        events: function() {
            return _.extend({
                //"dblclick": "dblclick"
            }, this.base.events())
        },
        initialize: function() {
            this.base.initialize.apply(this, arguments)
        },
        close: function() {
            this.base.close.apply(this, arguments)
        }
    })
    
    var baseview = ItemEditInlineView 
    
    ItemEditViews[type] = baseview.extend({
        minwidth: 6,
        render: function() {
            baseview.prototype.render.apply(this, arguments)
            return this
        },
        events: function() {
            return _.extend({
                //"dblclick": "dblclick"
            }, baseview.prototype.events())
        },
        initialize: function() {
            baseview.prototype.initialize.apply(this, arguments)
        },
        close: function() {
            baseview.prototype.close.apply(this, arguments)
        }
    })

})()
