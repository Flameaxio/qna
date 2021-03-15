import consumer from "./consumer"

consumer.subscriptions.create("CommentsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    let comment = data
    let string = `<li><span>${comment.email}:</span> ${comment.body}</li>`
    if(comment.commentable_type === 'Question'){
      $('.question-comment-list').append(string)
    }else{
      $('.answer-'+comment.commentable_id+'-comment-list').append(string)
    }
    let event = new CustomEvent("my-event");
    document.dispatchEvent(event);
  }
});
