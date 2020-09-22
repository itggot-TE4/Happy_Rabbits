prepareQuiz();
function prepareQuiz() {
    var allStudents = document.getElementsByClassName("student-fax");
    var students = [];
    var student = [];
    var i = 0;
    while(i < allStudents.length) {
        var id = allStudents[i].getElementsByClassName("id")["0"].innerHTML;
        var name = allStudents[i].getElementsByClassName("name")["0"].innerHTML;
        var img_path = allStudents[i].getElementsByClassName("img_path")["0"].innerHTML;
        student.push(id);
        student.push(name);
        student.push(img_path);
        students.push(student);
        i++;
    }
    setQuizImg(students);
}

function setQuizImg(students) {
    var img = document.getElementsByClassName("actual-img");
    
}