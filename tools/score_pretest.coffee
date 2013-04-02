_ = require("underscore")
async = require("async")
analytics = require("../api/analytics")
api = require("../api/api")
redis = require("redis").createClient()

undergrads = ["test", "admin", "naltimim@ucsd.edu","aamodei@ucsd.edu","latkins@ucsd.edu","aauyeung@ucsd.edu","mawasthi@ucsd.edu","ebarney@ucsd.edu","tbarnsto@ucsd.edu","cjbarton@ucsd.edu","sbijanpo@ucsd.edu","e1bloom@ucsd.edu","nbonanno@ucsd.edu","dbseiso@ucsd.edu","jcalais@ucsd.edu","svcampos@ucsd.edu","kcarrasc@ucsd.edu","amchambe@ucsd.edu","joc013@ucsd.edu","vwchang@ucsd.edu","wachao@ucsd.edu","ayc011@ucsd.edu","lwchen@ucsd.edu","rlc001@ucsd.edu","lwc001@ucsd.edu","yhc001@ucsd.edu","jwc025@ucsd.edu","gchuck@ucsd.edu","jcoss@ucsd.edu","ocostanz@ucsd.edu","tcranfor@ucsd.edu","rccuella@ucsd.edu","rcusing@ucsd.edu","sdangelo@ucsd.edu","jldejesu@ucsd.edu","jdefalco@ucsd.edu","mdejosep@ucsd.edu","bdhaliwa@ucsd.edu","gsdhillo@ucsd.edu","jjdiamon@ucsd.edu","tdomingo@ucsd.edu","ccduong@ucsd.edu","l2duong@ucsd.edu","amfreema@ucsd.edu","jgarafal@ucsd.edu","vngarcia@ucsd.edu","rgosavi@ucsd.edu","cgov@ucsd.edu","vaguerre@ucsd.edu","mgumina@ucsd.edu","pguzman@ucsd.edu","csha@ucsd.edu","kjhaley@ucsd.edu","hnhall@ucsd.edu","nhalstea@ucsd.edu","sharihar@ucsd.edu","crharmon@ucsd.edu","aheredic@ucsd.edu","jherzber@ucsd.edu","tahirota@ucsd.edu","tbhoang@ucsd.edu","vkhollin@ucsd.edu","sfhoward@ucsd.edu","jyhsi@ucsd.edu","eehsieh@ucsd.edu","thuezo@ucsd.edu","aphunter@ucsd.edu","rihu@ucsd.edu","nishiko@ucsd.edu","cjameson@ucsd.edu","akamgarp@ucsd.edu","nskanani@ucsd.edu","myk009@ucsd.edu","rkedlaya@ucsd.edu","emk005@ucsd.edu","hhk007@ucsd.edu","dkrishna@ucsd.edu","lakumar@ucsd.edu","rolam@ucsd.edu","a4lau@ucsd.edu","klavi@ucsd.edu","abl004@ucsd.edu","c7le@ucsd.edu","jnl004@ucsd.edu","ttl018@ucsd.edu","tlederge@ucsd.edu","erl004@ucsd.edu","jhl054@ucsd.edu","sol015@ucsd.edu","jil066@ucsd.edu","chl159@ucsd.edu","t9lin@ucsd.edu","clinsche@ucsd.edu","mcliu@ucsd.edu","tsliu@ucsd.edu","slunardi@ucsd.edu","elundste@ucsd.edu","siluong@ucsd.edu","amacari@ucsd.edu","cmagana@ucsd.edu","lmai@ucsd.edu","smandavg@ucsd.edu","smannino@ucsd.edu","kmanveli@ucsd.edu","jcmcelfr@ucsd.edu","elmeltze@ucsd.edu","ntmercer@ucsd.edu","ametzler@ucsd.edu","jmeyers@ucsd.edu","smezher@ucsd.edu","kmiu@ucsd.edu","e3moon@ucsd.edu","rnassimi@ucsd.edu","sneugros@ucsd.edu","qpnguyen@ucsd.edu","tbn006@ucsd.edu","tbn004@ucsd.edu","tin006@ucsd.edu","nnocum@ucsd.edu","aknoda@ucsd.edu","asobrien@ucsd.edu","rmohara@ucsd.edu","aworr@ucsd.edu","aoveroye@ucsd.edu","apainter@ucsd.edu","apatil@ucsd.edu","jperches@ucsd.edu","kapeterk@ucsd.edu","spetit@ucsd.edu","nppham@ucsd.edu","adphuong@ucsd.edu","raportil@ucsd.edu","fqafiti@ucsd.edu","qquarles@ucsd.edu","kmquigle@ucsd.edu","creuter@ucsd.edu","earivera@ucsd.edu","grorem@ucsd.edu","krosendo@ucsd.edu","rsablove@ucsd.edu","asaini@ucsd.edu","lrsakata@ucsd.edu","psamermi@ucsd.edu","ssamples@ucsd.edu","d2scott@ucsd.edu","eseubert@ucsd.edu","m8shin@ucsd.edu","isimpelo@ucsd.edu","lesolano@ucsd.edu","v1solis@ucsd.edu","wstahl@ucsd.edu","csubrahm@ucsd.edu","psukaviv@ucsd.edu","jrsyang@ucsd.edu","gtalan@ucsd.edu","rtalia@ucsd.edu","bltang@ucsd.edu","dtang@ucsd.edu","dttran@ucsd.edu","jet004@ucsd.edu","a1tse@ucsd.edu","emtse@ucsd.edu","etuma@ucsd.edu","alturner@ucsd.edu","mudo@ucsd.edu","mrvargas@ucsd.edu","jvillads@ucsd.edu","mwedeen@ucsd.edu","nawells@ucsd.edu","mrwestfa@ucsd.edu","jcw020@ucsd.edu","k8wong@ucsd.edu","elyang@ucsd.edu","gtyang@ucsd.edu","v2yu@ucsd.edu"]

gradstudents = ["asalexan@ucsd.edu","kblackst@ucsd.edu","kbolden@ucsd.edu","sdeanda@ucsd.edu","krhendri@ucsd.edu","minfante@ucsd.edu","nkucukbo@ucsd.edu","sbmacken@ucsd.edu","anair@ucsd.edu","vipatt@ucsd.edu","m1robled@ucsd.edu","ajschork@ucsd.edu","rtibbles@ucsd.edu","e1walker@ucsd.edu","cadance@ucsd.edu"]

students = undergrads

probes = ["4f7e4dddf7912a2618000001","4f7e4ddef7912a2618000002","4f7e4ddef7912a2618000003","4f7e4ddef7912a2618000004","4f7e4ddff7912a2618000005","4f7e4ddff7912a2618000006","4f7e4de0f7912a2618000007","4f7e4de0f7912a2618000008","4f7e4de0f7912a2618000009","4f7e4de1f7912a261800000a","4f7e4de1f7912a261800000b","4f7e4de2f7912a261800000c","4f7e4de2f7912a261800000d","4f7e4de2f7912a261800000e","4f7e4de3f7912a261800000f","4f7e4de3f7912a2618000010","4f7e4de4f7912a2618000011","4f7e4de4f7912a2618000012","4f7e4de4f7912a2618000013","4f7e4de5f7912a2618000014","4f7e4de5f7912a2618000015","4f7e4de6f7912a2618000016","4f7e4de6f7912a2618000017","4f7e4de7f7912a2618000018","4f7e4de7f7912a2618000019","4f7e4de8f7912a261800001a","4f7e4de8f7912a261800001b","4f7e4de9f7912a261800001c","4f7e4de9f7912a261800001d","4f7e4deaf7912a261800001e","4f7e4deaf7912a261800001f","4f7e4deaf7912a2618000020","4f7e4debf7912a2618000021","4f7e4debf7912a2618000022","4f7e4decf7912a2618000023","4f7e4decf7912a2618000024","4f7e4dedf7912a2618000025","4f7e4dedf7912a2618000026","4f7e4deef7912a2618000027","4f7e4deef7912a2618000028","4f7e4deff7912a2618000029","4f7e4df0f7912a261800002a","4f7e4df0f7912a261800002b","4f7e4df1f7912a261800002c","4f7e4df1f7912a261800002d","4f7e4df2f7912a261800002e","4f7e4df2f7912a261800002f","4f7e4df3f7912a2618000030","4f7e4df4f7912a2618000031","4f7e4df4f7912a2618000032","4f7e4df5f7912a2618000033","4f7e4df5f7912a2618000034","4f7e4df6f7912a2618000035","4f7e4df6f7912a2618000036","4f7e4df7f7912a2618000037","4f7e4df7f7912a2618000038","4f7e4df8f7912a2618000039","4f7e4df8f7912a261800003a","4f7e4df9f7912a261800003b","4f7e4dfaf7912a261800003c","4f7e4dfaf7912a261800003d","4f7e4dfbf7912a261800003e","4f7e4dfbf7912a261800003f","4f7e4dfcf7912a2618000040","4f7e4dfdf7912a2618000041","4f7e4dfdf7912a2618000042","4f7e4dfef7912a2618000043","4f7e4dfef7912a2618000044","4f7e4dfff7912a2618000045","4f7e4dfff7912a2618000046","4f7e4e00f7912a2618000047","4f7e4e01f7912a2618000048","4f7e4e01f7912a2618000049","4f7e4e02f7912a261800004a","4f7e4e02f7912a261800004b","4f7e4e03f7912a261800004c","4f7e4e04f7912a261800004d","4f7e4e04f7912a261800004e","4f7e4e05f7912a261800004f","4f7e4e05f7912a2618000050","4f7e4e06f7912a2618000051","4f7e4e06f7912a2618000052","4f7e4e07f7912a2618000053","4f7e4e08f7912a2618000054","4f7e4e08f7912a2618000055","4f7e4e09f7912a2618000056","4f7e4e09f7912a2618000057","4f7e4e0af7912a2618000058","4f7e4e0af7912a2618000059","4f7e4e0bf7912a261800005a","4f7e4e0cf7912a261800005b","4f7e4e0cf7912a261800005c","4f7e4e0df7912a261800005d","4f7e4e0df7912a261800005e","4f7e4e0ef7912a261800005f","4f7e4e0ff7912a2618000060","4f7e4e0ff7912a2618000061","4f7e4e10f7912a2618000062","4f7e4e10f7912a2618000063","4f7e4e11f7912a2618000064","4f7e4e11f7912a2618000065","4f7e4e12f7912a2618000066","4f7e4e13f7912a2618000067","4f7e4e13f7912a2618000068","4f7e4e14f7912a2618000069","4f7e4e15f7912a261800006a","4f7e4e15f7912a261800006b","4f7e4e16f7912a261800006c","4f7e4e17f7912a261800006d","4f7e4e17f7912a261800006e","4f7e4e18f7912a261800006f","4f7e4e18f7912a2618000070","4f7e4e19f7912a2618000071","4f7e4e1af7912a2618000072","4f7e4e1af7912a2618000073","4f7e4e1bf7912a2618000074","4f7e4e1cf7912a2618000075","4f7e4e1cf7912a2618000076","4f7e4e1df7912a2618000077","4f7e4e1ef7912a2618000078","4f7e4e1ff7912a2618000079","4f7e4e1ff7912a261800007a","4f7e4e20f7912a261800007b","4f7e4e21f7912a261800007c","4f7e4e23f7912a261800007d","4f7e4e24f7912a261800007e","4f7e4e26f7912a261800007f","4f7e4e28f7912a2618000080","4f7e4e29f7912a2618000081","4f7e4e2af7912a2618000082","4f7e4e2cf7912a2618000083","4f7e4e2df7912a2618000084","4f7e4e2ef7912a2618000085","4f7e4e2ff7912a2618000086","4f7e4e31f7912a2618000087","4f7e4e32f7912a2618000088","4f7e4e33f7912a2618000089","4f7e4e34f7912a261800008a","4f7e4e35f7912a261800008b","4f7e4e36f7912a261800008c","4f7e4e37f7912a261800008d","4f7e4e38f7912a261800008e","4f7e4e39f7912a261800008f","4f7e4e3af7912a2618000090","4f7e4e3bf7912a2618000091","4f7e4e3cf7912a2618000092","4f7e4e3cf7912a2618000093","4f7e4e3df7912a2618000094","4f7e4e3ef7912a2618000095","4f7e4e3ff7912a2618000096","4f7e4e40f7912a2618000097","4f7e4e40f7912a2618000098","4f7e4e41f7912a2618000099","4f7e4e42f7912a261800009a","4f7e4e42f7912a261800009b","4f7e4e43f7912a261800009c","4f7e4e44f7912a261800009d","4f7e4e45f7912a261800009e","4f7e4e45f7912a261800009f","4f7e4e46f7912a26180000a0","4f7e4e47f7912a26180000a1","4f7e4e48f7912a26180000a2","4f7e4e49f7912a26180000a3","4f7e4e49f7912a26180000a4","4f7e4e4af7912a26180000a5","4f7e4e4bf7912a26180000a6","4f7e4e4cf7912a26180000a7","4f7e4e4df7912a26180000a8","4f7e4e4ef7912a26180000a9","4f7e4e4ef7912a26180000aa","4f7e4e50f7912a26180000ab","4f7e4e51f7912a26180000ac","4f7e4e52f7912a26180000ad","4f7e4e52f7912a26180000ae","4f7e4e53f7912a26180000af","4f7e4e54f7912a26180000b0","4f7e4e55f7912a26180000b1","4f7e4e56f7912a26180000b2","4f7e4e57f7912a26180000b3","4f7e4e57f7912a26180000b4","4f7e4e58f7912a26180000b5","4f7e4e59f7912a26180000b6","4f7e4e5af7912a26180000b7","4f7e4e5bf7912a26180000b8","4f7e4e5cf7912a26180000b9","4f7e4e5cf7912a26180000ba","4f7e4e5df7912a26180000bb","4f7e4e5ef7912a26180000bc","4f7e4e5ff7912a26180000bd","4f7e4e60f7912a26180000be","4f7e4e61f7912a26180000bf","4f7e4e62f7912a26180000c0","4f7e4e63f7912a26180000c1","4f7e4e63f7912a26180000c2","4f7e4e64f7912a26180000c3","4f7e4e65f7912a26180000c4","4f7e4e66f7912a26180000c5","4f7e4e67f7912a26180000c6","4f7e4e68f7912a26180000c7","4f7e4e69f7912a26180000c8","4f7e4e6af7912a26180000c9","4f7e4e6af7912a26180000ca","4f7e4e6bf7912a26180000cb","4f7e4e6cf7912a26180000cc","4f7e4e6df7912a26180000cd","4f7e4e6ef7912a26180000ce","4f7e4e6ff7912a26180000cf","4f7e4e70f7912a26180000d0","4f7e4e71f7912a26180000d1","4f7e4e71f7912a26180000d2","4f7e4e72f7912a26180000d3","4f7e4e73f7912a26180000d4","4f7e4e74f7912a26180000d5","4f7e4e75f7912a26180000d6","4f7e4e76f7912a26180000d7","4f7e4e76f7912a26180000d8","4f7e4e77f7912a26180000d9","4f7e4e78f7912a26180000da","4f7e4e79f7912a26180000db","4f7e4e7af7912a26180000dc","4f7e4e7bf7912a26180000dd","4f7e4e7bf7912a26180000de","4f7e4e7cf7912a26180000df","4f7e4e7df7912a26180000e0","4f7e4e7ef7912a26180000e1","4f7e4e7ff7912a26180000e2","4f7e4e80f7912a26180000e3","4f7e4e81f7912a26180000e4","4f7e4e82f7912a26180000e5","4f7e4e83f7912a26180000e6","4f7e4e84f7912a26180000e7","4f7e4e85f7912a26180000e8","4f7e4e86f7912a26180000e9","4f7e4e86f7912a26180000ea","4f7e4e87f7912a26180000eb","4f7e4e88f7912a26180000ec","4f7e4e89f7912a26180000ed","4f7e4e8af7912a26180000ee"]

probeanswers = {}

probes.forEach (probe) =>
    id = probe
    if id.length isnt 24
        console.log id.length, id, typeof id
        return
    api.db.collection("probe").findOne _id: new api.ObjectId(id), (err, fullprobe) =>
        probeanswers[id] = fullprobe.answers
                # if not _.isString(probeanswers[id])
                # probeanswers[id] = probeanswers[id]._id
                # else
                    # console.log fullprobe.answers

                # fullprobe.answers.forEach (answer) =>
                #     nuggetpoints[nugget._id] += answer.correct or 0
        

addScores = =>
    analytics.db.collection("pretest").find(type: "pretestresponse").toArray (err, pretestresponses) =>
        pretestresponses.forEach (response) =>
            response.totalanswers = probeanswers[response.probe].length
            correct = (answer._id.toString() for answer in probeanswers[response.probe] when answer.correct)
            response.totalanswerscorrect = correct.length
            response.givenanswers = response.answers.length
            response.givenanswerscorrect = _.intersection(response.answers,correct).length
            response.points = Math.max(0, response.givenanswerscorrect - Math.max(0, response.givenanswers - response.totalanswerscorrect))
            # if response.points == 0
            #     console.log (typeof(answer._id) for answer in probeanswers[response.probe]), (typeof(id) for id in response.answers)
            analytics.db.collection("pretest").save(response)

setTimeout addScores, 2000

# // JS: 
# people = db.final.group({key: {email: true}, cond: {type: "proberesponse"}, initial: {points: 0, max: 0}, reduce: function(response, agg) {agg.points += response.points; agg.max += response.totalanswerscorrect;}, finalize: function(agg) {agg.percent = 100 * agg.points / agg.max;}})

# # coffee
# top = (person for person in people when person.points > 250)


midtermgradeboundaries = [188,180,174,168,160,157,154,150,147,137,0]

finalgradeboundaries = [329,315,305,294,280,275,270,263,257,240,0]

gradeboundaries = finalgradeboundaries

grades = ['A+','A','A-','B+','B','B-','C+','C','C-','D','F']

analytics.db.collection("pretest").group(
    {email:true}
    {type:"pretestresponse"}
    {csum:0,count:0,score:0, maxscore:0}
    (obj,prev) -> 
        prev.csum+=obj.responsetime
        prev.count++
        prev.score+=obj.points
        prev.maxscore+=obj.totalanswerscorrect
    (out) ->
        out.avg_time = out.csum/out.count
        out.percent = out.score/out.maxscore
        out.grade = grades[(out.score>=x for x in gradeboundaries).indexOf(true)]
    (err, people) =>
        for person in people
            # if person.score < 100 then continue
            if person.email in students
                grade = grades[(person.score>=x for x in gradeboundaries).indexOf(true)]
                api.db.collection("grade").save points: person.score, grade: grade, email: person.email, title: "Pretest"
            
)

#mongoexport --db analytics --collection midterm -q '{"type":"proberesponse"}' -o midterm.json --jsonArray
