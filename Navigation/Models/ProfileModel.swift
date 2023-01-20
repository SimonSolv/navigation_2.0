import UIKit

struct MyPost {
    var title: String?
}

struct PostBody {
    var title: String
    var imageName: String
    var bodyText: String
    var likes: Int16
    var views: Int16
}



struct News: Codable {
    var articles: [Article]
    
}

struct Article: Codable {
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
}

// https://newsapi.org/v2/top-headlines?country=ru&apiKey=4d3913c1ba72456ba01a30bd96e6c741

/*"status": "ok",
  "totalResults": 30,
  "articles": [
    {
      "source": {
        "id": null,
        "name": "Sport-express.ru"
      },
      "author": "Андрей Кузичев",
      "title": "Еще одна сенсация на ЧМ-2022: японцы из бундеслиги нокаутировали Германию! - Спорт-Экспресс",
      "description": "Турнир в Катаре точно войдет в историю.",
      "url": "https://www.sport-express.ru/football/world/2022/reviews/germaniya-yaponiya-1-2-obzor-matcha-pervogo-tura-gruppovogo-etapa-chm-2022-23-noyabrya-2022-goda-2002122/",
      "urlToImage": "https://ss.sport-express.ru/userfiles/materials/183/1839303/large.jpg",
      "publishedAt": "2022-11-23T15:35:02Z",
      "content": ".   .       . ,   , , ,  , .\r\n      « ».     (5:2).        .   - ,     .\r\n  ,     ? , , , , , ...         ,   18 . , ,    ,   ,   «», .\r\n , , .   ,     .   ,    ,  .        -2014 .\r\n  \r\n  ,     .   ,… [+354 chars]"
    },

*/


struct ImageSet {
    let rowIndex: Int
    let image: UIImage
}

struct PostAtributes {
    let sectionHeader: UITableViewHeaderFooterView?
    let body: [PostBody]
    var footer: String?
}
let header = ProfileTableHeaderView()

struct PostStorage {
    static let tableModel = [
        PostAtributes(sectionHeader: header,
                      body: [
                        PostBody(title: "Россияне в августе взяли рекордный объем потребкредитов",
                                 imageName: "Photo1",
                                 bodyText: "В августе рынок необеспеченного кредитования в России снова оживился после временного замедления в июле, следует из предварительных расчетов Frank RG (есть у РБК). Банки одобрили гражданам 2,1 млн кредитов наличными на 646,7 млрд руб., обновив рекорд по выдачам в этом сегменте, поставленный в апреле. По сравнению с июлем количество новых договоров выросло на 7,5%, а объем одобренных ссуд — на 6,9%",
                                 likes: 22, views: 111),
                        PostBody(title: "Борис Джонсон повысит налоги, в том числе на дивиденды",
                                 imageName: "Photo2",
                                 bodyText: "Премьер-министр Великобритании Борис Джонсон объявил во вторник о планах повышения налогов для финансирования здравоохранения и реформы системы социального обеспечения страны, пишет CNBC. Предполагается повышение ставки национального страхования в Великобритании (это текущий подоходный налог) на 1,25%, который станет отдельным налогом на трудовой доход в 2023 году, а также повышение налога на дивидендный доход акционеров.",
                                 likes: 12,
                                 views: 644),
                        PostBody(title: "Segezha рассматривает международный листинг, наращивая активы",
                                 imageName: "Photo3",
                                 bodyText: "Российский вертикально-интегрированный лесопромышленный холдинг Segezha, не так давно вышедший на рынки акционерного капитала, может рассмотреть международный листинг в конце 2022 года - в 2023 году, сказал Рейтер вице-президент компании по финансам и инвестициям Ровшан Алиев.\"По мере того, как мы будем расти, мы будем смотреть на dual listing по акциям. На данном этапе я не вижу необходимости, но мы можем вернуться к этому вопросу к концу 2022 года - в начале 2023\", - сказал Алиев.",
                                 likes: 255,
                                 views: 808),
                        PostBody(title: "Доллар в плюсе за счет роста доходности гособлигаций США",
                                 imageName: "Photo4",
                                 bodyText: "Доллар во вторник растет второй день подряд, отступая от почти месячного минимума, достигнутого на прошлой неделе, поскольку подъем доходности казначейских облигаций США побудил инвесторов сократить короткие позиции в паре доллар/евро перед заседанием Европейского центрального банка на этой неделе.Американская валюта в пятницу опустилась до минимальных уровней с начала августа после неожиданно слабого отчета о занятости в США, который заставил аналитиков повысить ставки на то, что Федеральная резервная система не будет сворачивать стимулы в ближайшие месяцы.",
                                 likes: 203,
                                 views: 901)
                      ] )
    ]
}

struct PhotoStorage {
    var photoGrid = [ ImageSet(rowIndex: 0, image: UIImage(named: "Image1")!),
                      ImageSet(rowIndex: 1, image: UIImage(named: "Image2")!),
                      ImageSet(rowIndex: 2, image: UIImage(named: "Image3")!),
                      ImageSet(rowIndex: 3, image: UIImage(named: "Image4")!),
                      ImageSet(rowIndex: 4, image: UIImage(named: "Image5")!),
                      ImageSet(rowIndex: 5, image: UIImage(named: "Image6")!),
                      ImageSet(rowIndex: 6, image: UIImage(named: "Image7")!),
                      ImageSet(rowIndex: 7, image: UIImage(named: "Image8")!),
                      ImageSet(rowIndex: 8, image: UIImage(named: "Image9")!),
                      ImageSet(rowIndex: 9, image: UIImage(named: "Image10")!),
                      ImageSet(rowIndex: 10, image: UIImage(named: "Image11")!),
                      ImageSet(rowIndex: 11, image: UIImage(named: "Image12")!),
                      ImageSet(rowIndex: 12, image: UIImage(named: "Image13")!),
                      ImageSet(rowIndex: 13, image: UIImage(named: "Image14")!),
                      ImageSet(rowIndex: 14, image: UIImage(named: "Image15")!),
                      ImageSet(rowIndex: 15, image: UIImage(named: "Image16")!),
                      ImageSet(rowIndex: 16, image: UIImage(named: "Image17")!),
                      ImageSet(rowIndex: 17, image: UIImage(named: "Image18")!),
                      ImageSet(rowIndex: 18, image: UIImage(named: "Image19")!),
                      ImageSet(rowIndex: 19, image: UIImage(named: "Image20")!)
    ]
    var photos = [UIImage(named: "Image1")!,
                  UIImage(named: "Image2")!,
                  UIImage(named: "Image3")!,
                  UIImage(named: "Image4")!,
                  UIImage(named: "Image5")!,
                  UIImage(named: "Image6")!,
                  UIImage(named: "Image7")!,
                  UIImage(named: "Image8")!,
                  UIImage(named: "Image9")!,
                  UIImage(named: "Image10")!,
                  UIImage(named: "Image11")!,
                  UIImage(named: "Image12")!,
                  UIImage(named: "Image13")!,
                  UIImage(named: "Image14")!,
                  UIImage(named: "Image15")!,
                  UIImage(named: "Image16")!,
                  UIImage(named: "Image17")!,
                  UIImage(named: "Image18")!,
                  UIImage(named: "Image19")!,
                  UIImage(named: "Image20")!
                  ]
 
}
