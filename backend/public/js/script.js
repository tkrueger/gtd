
// Our overall AppView is the top-level piece of UI.
var ThoughtsView = Backbone.View.extend({
    // Instead of generating a new element, bind to the existing skeleton of
    // the App already present in the HTML.
    el: $("#thoughts-view"),
    // Our template for the line of statistics at the bottom of the app.
    thoughtsTemplate: _.template($('#thoughts-template').html()),
    // Delegated events for creating new items, and clearing completed ones.
    events: {
        //"keypress #new-todo":  "createOnEnter",
        //"keyup #new-todo":     "showTooltip",
        //"click .todo-clear a": "clearCompleted"
    },
    initialize: function() {

    },
    // Re-rendering the App just means refreshing the statistics -- the rest
    // of the app doesn't change.
    render: function() {
        console.log("rendering ThoughtsView.");

        console.log("fetching thoughts")
        this.collection = new Thougts()
        this.collection.fetch({
            success: function() {
                console.log("succeeded in loading thoughts.")
                console.log("")
            },
            error: function() {console.log("failed loading thoughts.")}
        })
    }
});

var Thought = Backbone.Model.extend({
    idAttribute: "id",
    defaults: function() {
        return {
            text: "Fill me..."
        }
    }
});

var Thougts = Backbone.Collection.extend({
    url: '/api/thoughts',
    model: Thought
});

console.log("loaded.");
new ThoughtsView().render()
