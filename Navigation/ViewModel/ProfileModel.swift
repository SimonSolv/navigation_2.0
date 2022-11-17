import UIKit

struct PostBody {
    let title: String
    let image: UIImage
    let description: String
    var likes: Int
    var views: Int
}
struct ImageSet {
    let rowIndex: Int
    let image: UIImage
}

struct PostAtributes {
    let sectionHeader: UITableViewHeaderFooterView?
    let body: [PostBody]
    var footer: String?
}
let header: ProfileTableHeaderView = {
   let view = ProfileTableHeaderView()
    return view
}()


struct PostStorage {
    static let tableModel = [
        PostAtributes(sectionHeader: header,
                      body: [
                        PostBody(title: "Россияне в августе взяли рекордный объем потребкредитов",
                                 image: UIImage(named: "Photo1")!,
                                 description: "В августе рынок необеспеченного кредитования в России снова оживился после временного замедления в июле, следует из предварительных расчетов Frank RG (есть у РБК). Банки одобрили гражданам 2,1 млн кредитов наличными на 646,7 млрд руб., обновив рекорд по выдачам в этом сегменте, поставленный в апреле. По сравнению с июлем количество новых договоров выросло на 7,5%, а объем одобренных ссуд — на 6,9%",
                                 likes: 22, views: 111),
                        PostBody(title: "Борис Джонсон повысит налоги, в том числе на дивиденды",
                                 image: UIImage(named: "Photo2")!,
                                 description: "Премьер-министр Великобритании Борис Джонсон объявил во вторник о планах повышения налогов для финансирования здравоохранения и реформы системы социального обеспечения страны, пишет CNBC. Предполагается повышение ставки национального страхования в Великобритании (это текущий подоходный налог) на 1,25%, который станет отдельным налогом на трудовой доход в 2023 году, а также повышение налога на дивидендный доход акционеров.",
                                 likes: 12,
                                 views: 644),
                        PostBody(title: "Segezha рассматривает международный листинг, наращивая активы",
                                 image: UIImage(named: "Photo3")!,
                                 description: "Российский вертикально-интегрированный лесопромышленный холдинг Segezha, не так давно вышедший на рынки акционерного капитала, может рассмотреть международный листинг в конце 2022 года - в 2023 году, сказал Рейтер вице-президент компании по финансам и инвестициям Ровшан Алиев.\"По мере того, как мы будем расти, мы будем смотреть на dual listing по акциям. На данном этапе я не вижу необходимости, но мы можем вернуться к этому вопросу к концу 2022 года - в начале 2023\", - сказал Алиев.",
                                 likes: 255,
                                 views: 808),
                        PostBody(title: "Доллар в плюсе за счет роста доходности гособлигаций США",
                                 image: UIImage(named: "Photo4")!,
                                 description: "Доллар во вторник растет второй день подряд, отступая от почти месячного минимума, достигнутого на прошлой неделе, поскольку подъем доходности казначейских облигаций США побудил инвесторов сократить короткие позиции в паре доллар/евро перед заседанием Европейского центрального банка на этой неделе.Американская валюта в пятницу опустилась до минимальных уровней с начала августа после неожиданно слабого отчета о занятости в США, который заставил аналитиков повысить ставки на то, что Федеральная резервная система не будет сворачивать стимулы в ближайшие месяцы.",
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
}
