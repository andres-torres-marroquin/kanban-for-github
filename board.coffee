class Board
  constructor: (@repo_url, @container, @client) ->

  get_phases: ->
    labels = @client.get_labels()
    regex = /Phase #\d+ - .+/
    phases = (label for label in labels when regex.test(label.name))
    phases.sort (a, b) ->
        if (a.name > b.name)
            return 1
        else if (a.name < b.name)
            return -1
        return 0
    return phases

  get_phases_display: ->
    (phase.name for phase in @get_phases())

  draw: ->

  draw_phase: (phase) ->

  draw_issue: (issue) ->


# Tests
client =
    get_labels: ->
        [
            {name: 'Phase #3 - Reviewing'}
            {name: 'backlog'}
            {name: 'Phase #2 - Working'}
            {name: 'andres1'}
            {name: 'andres2'}
            {name: 'Phase #1 - Ready'}
            {name: 'andres3'}
        ]

b = new Board('asd', 'asd', client)
phases = b.get_phases()
if phases[0].name != 'Phase #1 - Ready'
    throw "Exception"
if phases[1].name != 'Phase #2 - Working'
    throw "Exception"
if phases[2].name != 'Phase #3 - Reviewing'
    throw "Exception"

phases = b.get_phases_display()
if phases[0] != 'Phase #1 - Ready'
    throw "Exception"
if phases[1] != 'Phase #2 - Working'
    throw "Exception"
if phases[2] != 'Phase #3 - Reviewing'
    throw "Exception"


