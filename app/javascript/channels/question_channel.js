import consumer from "./consumer"

consumer.subscriptions.create("QuestionChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    let table = $('.questions_list')
    let question = data
    let string = `<tr>
    <td>` + question.title + `</td>
    <td>` + question.short_body + `</td>
    <td>` + question.user + `</td>
    <td><a href="`+ question.question_path +`">Show</a></td>`
    if(question.current_user != 0)
      string += `<td><a href="`+ question.question_path +`" data-method="delete">Destroy</a></td>`
    table.append(string)
  }
});
