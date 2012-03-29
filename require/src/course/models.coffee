define ["cs!base/models", "cs!lecture/models", "cs!assignment/models", "cs!content/models", "cs!page/models"], \
        (basemodels, lecturemodels, assignmentmodels, contentmodels, pagemodels) ->

    class CourseModel extends basemodels.LazyModel

        apiCollection: "course"

        relations: ->
            lectures:
                collection: lecturemodels.LectureCollection
                includeInJSON: ["title", "description", "scheduled", "page"]
            assignments:
                collection: assignmentmodels.AssignmentCollection
                includeInJSON: ["title", "description", "due", "page"]
            content:
                model: contentmodels.ContentModel
                includeInJSON: true

    class CourseCollection extends basemodels.LazyCollection
        model: CourseModel

    CourseModel: CourseModel