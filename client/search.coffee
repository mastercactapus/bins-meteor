
class SearchInterface
  constructor: (@collection, @domNode) ->
  getResults: (val="") =>
    tags = val.toLowerCase().split(" ")
    tags = _.compact tags
    @collection.find
      tags: $all:tags
    ,
      sort: title:1
  updateQuery: (val="") =>
    results =  @getResults(val)
    console.log results.count()
    doms = Meteor.renderList results, Template.searchItem
    $(@domNode).empty().append doms
