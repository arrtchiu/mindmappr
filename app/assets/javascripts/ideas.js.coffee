# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  socket = io.connect 'http://localhost:3001'

  socket.on 'idea-event', (rocketData) ->
    rocketData = JSON.parse rocketData

    if rocketData.op == 'add'
      idea = rocketData.value

      # Build the DOM elements for the new idea
      ideaElement = $('<li>').addClass('idea').attr('data-id', idea.id)
        .text(idea.content).append($('<ul>').addClass('idea-children'))

      # Find the parent element where the new idea should go
      parentElement = $('.idea[data-id=' + idea.parent_id + ']').children('.idea-children')
      parentElement.append(ideaElement)

      # Move the form to the bottom
      formItem = parentElement.children('.new-idea')
      parentElement.append(formItem)


  socket.emit('sub', $('.idea-root').first().attr('data-id'))
