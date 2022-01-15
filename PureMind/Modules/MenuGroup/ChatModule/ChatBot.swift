//
//  ChatBot.swift
//  PureMind
//
//  Created by Клим on 11.09.2021.
//

import Foundation

class ChatBot{
    //private init(){}
    //static let shared = ChatBot()
    
    let helloMessage = String("!отэ ан яслишер отч ,цедолом ыт И !оньламрон отэ -хаговерт ,хяицомэ ,хяинавижереп хиннертунв хиовс в ясьтарибзар или ищомоп о ьтисорп отч ,инмоп адгесВ .'утсилаицепс к учох'  укпонк имжан и юнем к ьситарбо оготэ ялд ,ясьтитарбо умен к ьшежом адгесв ыт ,мотсилаицепс ос ясьтащбооп еентрофмок олыб ебет отч ьшеаминоп ыт илсе ,кинщомоп ьшил я отч ,удивв йемИ .исипаз иовс итсев отсорп ежкат а ,иицомэ ,автсвуч иовс ьтасипан ,тиокопсеб ябет отч ,ьтазакссар ьшежом ыт ьседЗ .голохисп йыннамрак йовт Я ....тувоз янеМ !тевирП".reversed())
    var path = [Int]()
 
    func botResponse() -> [String]{
        switch path[0] {
        case 0: //Анализ состояния
            return pickScenario()
        case 1: // Упражнения
            let str1 = String(":ымет еынзар ан мытибзар ,мяиненжарпу к еинечюлкереП".reversed())
            return ["1", str1, "Эмоции", "Тело", "Медитации"]
            
        case 2: //Специалист
            return ["specialist", "Переключение на специалиста"]
        default:
            return ["error"]
        }
    }
    
    private func pickScenario() -> [String]{
        switch path.count {
        case 1:
            return ["2", String("!меиняотсос миовт с ясмеребзар йаваД !ошороХ".reversed()), String("?ьшеувтсвуч сачйес ябес ыт каК".reversed()), String("!яинещущо итэ ьтинмопаз учоХ !ончилто ябес юувтсвуч Я".reversed()), String("меиняотсос миовс дан ясьтарбозар ыб летох ,он онтрофмок юувтсвуч ябес Я".reversed()), String("меиняотсос миовс ос ясьтиварпс угом еН .юувтсвуч ябес охолП".reversed()), String("еиняотсос еовс ьтатобарорп учох ,онтрофмокен ябес юувтсвуч Я".reversed()), "Назад" ]
        case let x where x >= 2:
            switch path[1] {
            case 0: //00
                return ["1",String("йинещущО екинвенД в елифорп в или ьседз яинещущо иовс ьтасипаз ьшежом ыТ !ябет аз дар ьнечо Я !цедолом ыТ".reversed()), "Перейти в Дневник Ощущений"]
            case 1:  //01
                return bigRouteOne()
                
            case 2:  //02
               return bigRouteTwo()
            case 3:  //03
                return bigRouteThree()
                
            case 4: //04
                path = []
                return ["1", "Назад"]
                
            default:
                return ["error"]
            }
            
        default:
            return ["error"]
        }
    }
    
    private func bigRouteOne() -> [String]{
        switch path.count {
        case 2:
            return ["1", String("?ьтатобароп яндогес летох ыт ыб меч даН !ошороХ".reversed()), String("ииняотсос меовс ан ясьтичотодерсос учох икат есВ".reversed()), String("елет в имяинещущо дан ьтатобароп учоХ".reversed()), String("яинещущо иицомэ иовс ьтасипо отсорп учоХ".reversed())]
        
        case let x where x >= 3:
            switch path[2] {
            case 0: //010
                return routeOneChoiceZero(cases: [3, 4])
            case 1: //011
                return routeOneChoiceOne(cases: [3, 4])
            case 2: //012
                return ["1", String("йинещущО екинвенД в елифорп в или ьседз яинещущо иовс ьтасипаз ьшежом ыТ".reversed()), "Перейти в Дневник Ощущений" ]
                
            default:
                return ["error"]
            }
        default:
            return ["error"]
        }
    }
    
    private func routeOneChoiceZero(cases: [Int]) -> [String]{
        
        switch path.count {
        case cases[0]: //3
            return ["multi-sp",String("вотнаирав окьлоксен ьтитемто ьшежом ыТ .ьшеавытыпси сачйес ыт отч миледерпо йаваД !ошороХ".reversed()), "Мне грустно", "Мне обидно", "Мне одиноко", "Что-то тревожит", "Кажется, я злюсь", "Мне страшно", "Подтвердить" ,"Я не понимаю, что я испытываю"]
            
        case let x where x >= cases[1]: //4
            switch path[cases[1] - 1] {
            case 6: //0106 Подтвердить
                return ["5", String("еиняотсос еещукет еовс ьтатобарорп ебет тугомоп еыроток йиненжарпу окьлоксен ебет ужолдерп я сачйеС ьшеавытыпси ыт отч ьшеаминоп ыт отч онжав ьнечО оньламрон отэ ьшеавытыпси сачйес ыт отч оТ".reversed()), "-Тут должны быть упражнения-", String(".ясмемйаз и йобот с ым митЭ .ьтяноп и ьтянирп ьтанзосо хи онжав имяицомэ дан етобар В".reversed()), String(".имин дан ьтатобароп яслишер отч цедолом ыт ,иицомэ еытсорпен отЭ".reversed()), String("ухревс укпонк ан важан ,утсилаицепс к ясьтитарбо ьшежом ыт ,имяицомэ дан ьтатобар олежят ястивонатс ебет ,отч ьшемйоп ыт илсЕ".reversed())]
                
            case 7: //0107
                let str1 = "Попробуй определить, на какие из перечисленных чувств похоже то, что ты испытываешь?"
                return multiChoice1(botMessage: str1, cases: cases)
            default:
                return ["error"]
            }
        default:
            return ["error"]
        }
    }
    
    private func routeOneChoiceOne(cases: [Int]) -> [String]{
        switch path.count {
        case cases[0]:
            return ["3", String("?вотоГ .елет в яинещущо и еиняотсос еовт ьтаворизиланаорп тежомоп отЭ .мосолог аз ьтаводелс и ьташулс окьлот тедуб одан ебет ,ьсипаз ебет юлварпан я сачйеС .тяокопсебоп ен ябет едг ,отсем итйан ясйаратсоп ,онбоду ьдяС .меинахыд дан ытобар с ьтачан юагалдерП".reversed()), "-Происходит медитация посредством аудио файла-", String("?ьшеувтсвуч сачйес ябес ыт каК .оге ьтялбалссар и елет в ьсолипокан отч ,есв ьтаксупто теагомоп яицатидеМ .меавытыпси ым еыроток ,еинежярпан от и олет еовс ьтавовтсвуч ешчул и он ,меинаминв мишан дан ьтатобар окьлот ен ман теагомоп яицатидеМ .яивтсйокопс ешьлоб ябет у сачйес ,олет еовс ьшеувтсвуч ешчул ыт ,олет ешан илибалссар йобот с ым сачйеС !цедолоМ".reversed()), "Мне намного лучше! Спасибо!", "Мне полегчало но я бы поработал над своим телом еще немного." ]
            
        case let x where x >= cases[1]:
            switch path[cases[1] - 1] {
            case 0: //0110
                return ["2", String(".алет ялд яиненжарпу еледзар в ее итйан ьшежом ыт ,иицатидем юьщомоп с молет с утобар ябес ялд ьтиротвоп мынжав ьшеатичсоп ыт илсЕ".reversed()), String("!ебет угомоп адгесв Я .онжавен ябес ьшеувтсвучоп илсе ьтасипан енм ьшежом адгесв ыт И".reversed())]
            case 1: //0111
                return routeOneChoiceOneTwo(cases: cases)
            default:
                return ["error"]
            }
        default:
            return ["error"]
        }
    }
    
    private func routeOneChoiceOneTwo(cases: [Int]) -> [String]{
        switch path.count {
        case cases[0] + 1:
            return ["5", "Хорошо! Давай поработаем еще над ощущениями" ,String("алет ялд еиняотсос отэ еокак и елет в теашем ебет отч ,ьтавовтсвучоп ьшежомс адурт зеб ыт умотэоП .есв теанимопаз олет ешан а ,елет мешан в ястюавилпакан иицомэ ишан есВ".reversed()), "Давай начнем!", "-Происходит медитация посредством аудио файла-", "Как ты себя чувствуешь?", "Мне намного лучше! Спасибо!", "Еще что-то есть"]
        case cases[1] + 1:
            switch path[cases[1]] {
            case 0:
                return ["3", "Я очень рад!", String(".алет ялд яиненжарпу еледзар в ее итйан ьшежом ыт ,иицатидем юьщомоп с молет с утобар ябес ялд ьтиротвоп мынжав ьшеатичсоп ыт илсЕ".reversed()), String("!ебет угомоп адгесв Я .онжавен ябес ьшеувтсвучоп илсе ,ьтасипан енм ьшежом адгесв ыт И".reversed())]
            case 1:
                return ["1", "Я тебя понял! Давай посмотрим, что я смогу для тебя сделать", "Вернутся в начало к определению состояния", "Перейти в раздел по проработке эмоций", "Поработать с психологом"]
            default:
                return ["error"]
            }
        case let x where x >= cases[1] + 2:
            switch path[cases[1] + 1] {
            case 0:
                path = [0]
                return ["2", String("!меиняотсос миовт с ясмеребзар йаваД !ошороХ".reversed()), String("?ьшеувтсвуч сачйес ябес ыт каК".reversed()), String("!яинещущо итэ ьтинмопаз учоХ !ончилто ябес юувтсвуч Я".reversed()), String("меиняотсос миовс дан ясьтарбозар ыб летох ,он онтрофмок юувтсвуч ябес Я".reversed()), String("меиняотсос миовс ос ясьтиварпс угом еН .юувтсвуч ябес охолП".reversed()), String("еиняотсос еовс ьтатобарорп учох ,онтрофмокен ябес юувтсвуч Я".reversed()), "Назад" ]
            case 1:
                path = [0, 1]
                return ["1", String("?ьтатобароп яндогес летох ыт ыб меч даН !ошороХ".reversed()), String("ииняотсос меовс ан ясьтичотодерсос учох икат есВ".reversed()), String("елет в имяинещущо дан ьтатобароп учоХ".reversed()), String("яинещущо иицомэ иовс ьтасипо отсорп учоХ".reversed())]
            case 2:
                return ["-Работаем с психологом-"]
            default:
                return ["error"]
            }
            
        default:
            return ["error"]
        }
    }
    
    private func bigRouteTwo() -> [String]{
        switch path.count {
        case 2:
            return ["1", " Можешь ли ты оценить свое текущее состояние?", "Я чувствую себя ужасно. Мне очень нужна помощь.", "Я чувствую себя неважно. Хочу понять, что происходит внутри меня."]
        case 3:
            switch path[2] {
            case 0:
                return ["1", "Уверен ли ты, что хочешь разобраться со своим состоянием самостоятельно? Я бы рекомендовал поработать со специалистом. Переключить тебя?", "Нет, я хочу поработать самостоятельно", "Да, наверное так будет лучше"]
            case 1:
                return ["1", "-Что-то должно произойти-"]
            default:
                return ["error"]
            }
        case let x where x >= 4:
            switch path[3] {
            case 0:
                return routeTwoChoiceZeroZero()
            case 1:
               return ["1", "Переключение на специалиста"]
            default:
                return ["error"]
            }
        default:
            return ["error"]
        }
    }
    
    private func routeTwoChoiceZeroZero() -> [String]{
        switch path.count {
        case 4:
            return ["textRequiered", String("?ьсоличулс йобот с отч ,ьтазакссар ьшежом ,ьтяноп ябет ешчул ыботч оН .имяицомэ и имяинещущо имиовт с алачанс меатобароп йавад ,катИ".reversed()), "Возможность написать, что случилось: -ТРЕБУЕТСЯ ВВОД ТЕКСТА ОТ ПОЛЬЗОВАТЕЛЯ-"]
        case let x where x >= 5:
            switch path[4] {
            case 501:
                return situationResponse()
            default:
                return ["error"]
            }
        default:
            return ["error"]
        }
    }
    
    private func situationResponse() -> [String]{
        switch path.count {
        case 5:
            return ["3", String("ебет ьчомоп ьсюаратсоп Я .сачйес ебет олежят окьлоксан юялватсдерп Я".reversed()), String(".меиняотсос миовт дан ытобар ытнаирав еще ьтижолдерп и ябет ьтяноп ешчул угомс я А .елет в ястеажарто отэ едг ,ьтиделсто и ьшеавытыпси ыт отч ,от ьтяноп ешчул ебет тежомоп отЭ .елет в имяинещущо имиовс ос и имяицомэ имиовс ос ьтатобароп ебет ьтижолдерп угом Я".reversed()), "С чего начнем?", "Все-таки хочу сосредоточиться на своем состоянии", "Хочу поработать над ощущениями в теле"]
        case let x where x >= 6:
            switch path[5] {
            case 0:
                return routeOneChoiceZero(cases: [6, 7])
            case 1:
               return routeOneChoiceOne(cases: [6, 7])
            default:
                return ["error"]
            }
        default:
            return ["error"]
        }
    }
    
    private func bigRouteThree() -> [String]{
        switch path.count {
        case 2:
            return ["2", "Хорошо, я помогу тебе поработать со своими эмоциями и со своими ощущениями в теле. Это поможет тебе лучше понять то, что ты испытываешь и отследить, где это отражается в теле. А я смогу лучше понять тебя и предложить еще варианты работы над твоим состоянием.", "C чего начнем?", "Все таки хочу сосредаточиться на своем состоянии", "Хочу поработать над ощущениями в теле"]
            
        case let x where x >= 3:
            switch path[2] {
            case 0:
                return routeOneChoiceZero(cases: [3, 4])
            case 1:
               return routeOneChoiceOne(cases: [3, 4])
            default:
                return ["error"]
            }
        default:
            return ["error"]
        }
        
    }
    
    
    private func multiChoice1(botMessage: String, cases: [Int]) -> [String]{
        switch path.count {
        case cases[0] + 1:
            return ["multi", botMessage, "Мне грустно", "Мне обидно", "Мне одиноко", "Что-то тревожит", "Кажется, я злюсь", "Мне страшно", "Подтвердить"]
        case let x where x >= cases[1] + 1:
            switch path[cases[1]] {
            case 6: //01076
                return ["5", String("еиняотсос еещукет еовс ьтатобарорп ебет тугомоп еыроток йиненжарпу окьлоксен ебет ужолдерп я сачйеС ьшеавытыпси ыт отч ьшеаминоп ыт отч онжав ьнечО оньламрон отэ ьшеавытыпси сачйес ыт отч оТ".reversed()), "-Тут должны быть упражнения-", String(".ясмемйаз и йобот с ым митЭ .ьтяноп и ьтянирп ьтанзосо хи онжав имяицомэ дан етобар В".reversed()), String(".имин дан ьтатобароп яслишер отч цедолом ыт ,иицомэ еытсорпен отЭ".reversed()), String("ухревс укпонк ан важан ,утсилаицепс к ясьтитарбо ьшежом ыт ,имяицомэ дан ьтатобар олежят ястивонатс ебет ,отч ьшемйоп ыт илсЕ".reversed())]
            default:
                return ["error"]
            }
        default:
            return ["error"]
        }
    }
    
}
