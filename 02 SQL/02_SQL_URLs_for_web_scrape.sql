-- To scrape players' birth dates, I created an http address for each player. 
-- Http address does not support certain UTF-8 characters (symbols, none ASCII alphabets (Cyrilic, Japanese, Chinese) etc.), 
-- which I had to either replace or remove.

-- Statement to filter unwanted characters:
SELECT 
    LISTAGG(DISTINCT(REGEXP_SUBSTR("CurrentHandle", '[^0-9a-zA-Z]')), '') WITHIN GROUP(ORDER BY REGEXP_SUBSTR("CurrentHandle", '[^0-9a-zA-Z]')) 
    AS UNWANTED_NICKNAME
    LISTAGG(DISTINCT(REGEXP_SUBSTR("NameFirst", '[^0-9a-zA-Z]')), '') WITHIN GROUP(ORDER BY REGEXP_SUBSTR("NameFirst", '[^0-9a-zA-Z]')) 
    AS UNWANTED_FIRSTNAME
    LISTAGG(DISTINCT(REGEXP_SUBSTR("NameLast", '[^0-9a-zA-Z]')), '') WITHIN GROUP(ORDER BY REGEXP_SUBSTR("NameLast", '[^0-9a-zA-Z]')) 
    AS UNWANTED_LASTNAME
FROM API01_PLAYER;


/* creating table of http adressses:
Step one: handling unwanted characters
Unwanted characters are divided to 3 groups:
1. Characters to substitude for another ones (e.g.: ě -> e) or 
2. charaters to delete (e.g.: お).
   - For these two groups is TRANSLATE function ideal.
3. There were also special characters, which should be replaced by groups of characters (REPLACE function)
   ('Æ' -> 'ae', 'ß' -> 'sz', 'ð' -> 'eth', 'æ' -> 'ae') */


CREATE OR REPLACE TEMPORARY table TEMP_LINK AS
SELECT 
    "PlayerId", 
    -- for correctness check, I added original collumns (without replacing/deleting changes), but hey are not necessery
    "CurrentHandle",
    RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TRANSLATE("CurrentHandle", '._ ¡ÁÂÃÄÅÇÉÍÐÑÓÖØàáâãäåçèéêëìíîïñòóôõöøùúüýÿāăćČĐēęěİŁłńŇōŚśŜŠšũźŽžưạảấầậắếễệỉịỏỐốồổộờởủứữỳỹňşĺŨŸơǺÈÜûčūŹŻŰǍί"ΑΕΖΙΝΟΣΧΨΩαζουϹЅАБВЕЖИМНОПРСТФШЭавгеикморстухчэяёѕіเᏃᴺɟƧı!#$%&()*+,-./:;<>?@[]{}^_`|~²³¹’†′⁓™ℳ⑦☆♫⚡✨❤、あうえおかがくぐけこごさしじすぜそただちつてでとなにぬねのはぱひふぶへべぺぼまみむもやゆらりるろわアイカクスタデバプマミラワㅤ一丁七万三上不与东严中丶丸久么乌乐九了二于五亚京人今任企体余你佩侃來俊倒傻元光入全兩六兴冠冬冯冰冷凉凌凡凤凯出刀刘初别到剑劣勇勝北十千半卓单南博卧原厨古另叫叮可叶司同向吒吕君听周呵哈哦哩哲唐啊善喝喵嗜嘉嘘嘟囍团国坑坚垫執基塔墙墨夏多夜夢大天失奋奔奶如妖姑娘嫠子季孤宇安宝宮家宸宽宿小少尘就尹尾屁属岩川左已巴布帅希平幸幻幽広庭康弓张弹归影很徐微心忘快念思怠怪总恒悠悲情惊想慌慕懂成我战戦房打托扶拿指挚挽搁搬撬放教整文斗斩新无旧旬时昔星春昱晓晨晴智暑暖暗暮暴曲曼最月朔望朝朧本杀李杰极枉林果枪枫柒柠树核格桃桜梓梦梨棒榆樱橘正歪死毁毕毛気水永江汤汪沐没河波泼泽洋派流浅浩浪浮海涛涵清温渲演漫潇火灵烟烤焕無熊熙燈燕爱牛狗狸狼猪玉王玖环珠理瑶甜生用男疯疾白的皮盒盼真着瞬知石破磊祖神秀秉秋科空站竞章童端笑答米紅紫縱繁红纯罗翔老耐肥肯育胶臭航艾芬花苏若苦英范莫莺菊萧落蘑蘭虎虐虚虫虾蛋蛮蝴行街袁西见言诤请诺谜谨豆賴贺赖赛赫赵超越路跳蹦躺轨轩轻载辉辰运这进迷送逆逗造進遥邢邪邹郎郑郭都酒酱酷醉醒释野金钢银锁锋错长閻闪阳阴阿陆陈陌降随雨雪零雷雾霜青靓静韻项顾领风飞饼馬马驴骄高鬼魏鱼鲨鸡麓麦麻黄黑默黙龍龙龜강게고공괜구국권귤근길김깅꿀나남내노다달둘라러럭레렘로매맥문박발방배백별분상서소손송신심아안애약양열영오용원유윤이임자잔장재전절정조주진최치코콘킁탱팜표프하한핫현홍황=\γηνблнпфшщจᏌᴱẵọ ∩ぁぃいぉきぎずせぞっばびぷぽゃゅょよれをんィウケコッノハフブメルレンー下丨个主乃义之也乱予争云井亦介仔仙代们休会伟伦似位何佳依侠修倍假偶偷傲僧儿先克兒兔兰兽冉再冒军冻准击分利剧力劫势勒勺包化午华卫叁双叔变只号吃合后吐吞呀命咩品哟哥唯唱啥啪嘿四圆在地坤坦城域堂壢壹夕太头奇女妄妹委姛姜姬威字孙孝学孩孽宅客容寂寒寞寻尖尢尤尽居履山屿岁岛島崩崽工巧帝带席帮常干年幼庆底开弟弱强当形得德忆怀性恩恹悪惰意懒户手才扎执扬承技把投拔招掌排摂摳敏斌斯方既日旭旺明是昼晋晒木末机权杉条来杨杯某染柔柚查柳栀栎栖桀案桐桥森椒槌橋欣欧歌步殇比氏汉沉沛油洒洛涯渡港游潭澈濑点烦烬然照爆爷牙牢物狙独猜猫玮球琉琛琪琴瑞瑾璐瓜瓣电痕瘾皂盗省眠睡督睿砂砖碧確福禹离秘等筱简粪糖素索约级纳纸练终给维缘羊美羡群羽者肉胃腾自舞良色艺芒茉茶草荡莉莲菇菜萨蒼蓮薇藏虹蝶血衣袭裡要観觉解訫诚话语谦谷豪贤败贱躁输辞达远迪迭迹逍逸逼道遗酸里鉄鑫钧铁铛铭锥门间限隻雄雏電霖霸霾非面頭颜飘香駿骑骚骨魂魇魔魚鲁鵝鸟鸢鸣鸭鹿黎黒가감개건검경곰관기는늘니대더덕도동뜨렬론머면명모몬미민범베봉브비빈빛사산석선성세수순스승악언연예완우운웅은의인쟁좀종준중지집찮창처천철추캬콩킨탓태택퇴포플혁형호환훈️﻿６ϊКдйьอᎡᴹ❦〃ぇざどぴめ゜ガグゴチトドナネヤ丝乎乔仓伞传作使便像八兼冲凶加压吖员味咪噜噴回园壁士声奈好娇學定对将尔帕帽往怎恋愛戰抱揚故斬旅朽杂栄梧棍様欢欲武汁求沧泫涼深溃源滴炎焰煮特猎猖猛瑜璃甘異直看稚竹第绎義职聖背脑膏膨舍节芷药菌萌葩蓝薄蜂蜜見记貓費贝贼起跑过逊達那邰釣锦镜闭队险陶霞食鹅鹰鼻齐광규균꾼날덱드래록리말무봇살섭솔식와왕위을일제찬콜킬터투트티피헌홀희９őǷɪϻЛาᏩᴀ『オソホロ・世业乡供做停剣助勢吶咻圈巢度桑極歉残泪狂糕糞网翼胀袋说谁間闹顿鼠걀까롤릭메쓰알어잃펀험３ǾรᏆᴍᴛᴜげベリ养应式界茧部바커５ＲĿɴʙ์ᴇ商槍생ｙ\Ȉʟิᴏ彡ｚǝ้⓰ｅŖมｎแ』ƑǃɓτχГДЗЙХЧЯжзыю่ặẻềểỗự°·ĔŦʀιρวⓔ★ツ丂乾亮令仲伪凑凹則动劲勤卡又口台咖啄圣垃她奾妍姐娃娜幡建強彪彼悟拂撒收旋易曾札朱殘沒泉法泰澤煎片狮猩玩珊琳甲百絕羅肿芭莱萊萝营藤蘇补詩詹货贴车轮软还闷陵隨饭騒거교궁네당뚜롱링물보부쌀에엽함＿λϋⓖ▵ボ丘兵凸刹办取吧啡器因圾坎塞师座戏旦昂栉渣湿灣炼珩瓶绮能装裤贏辣钩锅關靠鸽계따람맞북후Ŋʍεⓞ係勁名嗆拙政更纱臨鈈震키？\Ǩύ巽～艮兑', '----aaaaaceidnoooaaaaaaceeeeiiiinoooooouuuyyaaccdeeeillnnosssssuzzzuaaaaaaeeeiioooooooouuuyynsluyoaeuucuzzuai'), 'Æ', 'ae'), 'ß', 'sz'), 'ð', 'eth' ), 'æ', 'ae' ), '-') as NICKNAME, --`
    "NameFirst",
    RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TRANSLATE("NameFirst", '._ ÁÅÇÈÉÍÐÓÖØÞàáâãäåçèéêëìíîïñòóôõöøùúüýþĀāăĄčĐđĒėěğĩīİŁłŅŐőřśŞşŠšũūŽžơưȘșţ̦̣̀́̂̌ẠạảấầẩậắếềễệịọốồổộợừửữỳņżặớờứÂÔÜēęĢģļň"⁬ΑΚАБЕКОгеёı渡?ιвнос​‎‏’辺﻿μдиртίайλοςΝВГДИМСлмỗụự神кь龙', '---aaceeidooodaaaaaaceeeeiiiinoooooouuuydaaaacddeeegiiillnoorsssssuuzzousstaaaaaaaaeeeeioooooouuuynzaoouaoueeggln'), 'Æ', 'ae'), 'ß', 'sz'), 'ð', 'eth' ), 'æ', 'ae' ), '-') AS FIRSTNAME,
    "NameLast",
    RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(TRANSLATE("NameLast", '._ ÁÅÇÉÓÖØÚÜàáâãäåçèéêëìíîïñòóôõöøùúüýĀāăąĆćČčĎĐđĒēėęěğģīİļŁłńņňőŘřŚśŞşŠšťũūůűŹźŻżŽžơưșȚțɫ̛̣̀́̂̆̈̌ạấầậắếềểễệịọốồứừữỳ"ΜНШуёı/?\´&ḑ̌̃πбеиặỗờ‎‘’﻿ρйлнέоч#;\σвιακςĶķАБЕИКПРСТХЦаảгзмрстхыю​жкф', '---aaceooouuaaaaaaceeeeiiiinoooooouuuyaaaaccccdddeeeeeggiilllnnnorrsssssstuuuuzzzzzzousttlaaaaaeeeeeiooouuuy'), 'Æ', 'ae'), 'ß', 'sz'), 'ð', 'eth' ), 'æ', 'ae' ), '-') AS LASTNAME,
FROM API01_PLAYER;

/*I created a table of http addresses. 
There were 8 combinations of FIRSTNAME, LASTNAME AND NICKNAME AND its missing variants,
and  also names of players from Asia have Last name on the first place, 
which was taken in account in the case of http adresses 
(Special Collumn "ShowLastNameFirst", which was in data from APIs 08 and 10).
It took 10 combinations together */

CREATE OR REPLACE table PLAYER_URL AS
WITH "LastNameFirst" AS (
SELECT DISTINCT "PlayerId" 
FROM (
        SELECT "PlayerId" 
        FROM API08_TOURNAMENT_RESULTS_INDIVIDUAL
        WHERE "ShowLastNameFirst" = 1
            UNION
        SELECT "PlayerId" 
        FROM API10_TOURNAMENT_RESULTS_PLAYER_IN_TEAM
        WHERE "ShowLastNameFirst" = 1
    ))

SELECT 
    CASE 
    WHEN NICKNAME is null AND FIRSTNAME is null AND LASTNAME is null 
    THEN lower(CONCAT('https://www.esportsearnings.com/players/', "PlayerId", '-')) 
    
    WHEN NICKNAME is null AND FIRSTNAME is null 
    THEN lower(CONCAT('https://www.esportsearnings.com/players/', "PlayerId", '-', LASTNAME))

    WHEN FIRSTNAME is null AND LASTNAME is null 
    THEN lower(CONCAT('https://www.esportsearnings.com/players/', "PlayerId", '-', NICKNAME)) 
    
    WHEN NICKNAME is null AND LASTNAME is null 
    THEN lower(CONCAT('https://www.esportsearnings.com/players/', "PlayerId", '-', FIRSTNAME)) 
    
    WHEN FIRSTNAME is null 
    THEN lower(CONCAT('https://www.esportsearnings.com/players/', "PlayerId", '-', NICKNAME, '-', LASTNAME))
    
    WHEN LASTNAME is null 
    THEN lower(CONCAT('https://www.esportsearnings.com/players/', "PlayerId", '-', NICKNAME, '-', FIRSTNAME))
    
    WHEN "PlayerId" IN (SELECT "PlayerId" FROM "LastNameFirst") AND
         NICKNAME is null 
    THEN lower(CONCAT('https://www.esportsearnings.com/players/', "PlayerId", '-', LASTNAME, '-', FIRSTNAME)) 
    WHEN "PlayerId" NOT IN (SELECT "PlayerId" FROM "LastNameFirst") AND
         NICKNAME is null 
    THEN lower(CONCAT('https://www.esportsearnings.com/players/', "PlayerId", '-', FIRSTNAME, '-', LASTNAME)) 
   
    WHEN "PlayerId" IN (SELECT "PlayerId" FROM "LastNameFirst") 
    -- set of players ids with Last-Name-First is much smaller then the opposite, therefore managing them first is quicker for processing
    THEN lower(CONCAT('https://www.esportsearnings.com/players/', "PlayerId", '-', NICKNAME, '-', LASTNAME, '-', FIRSTNAME))
    ELSE lower(CONCAT('https://www.esportsearnings.com/players/', "PlayerId", '-', NICKNAME, '-', FIRSTNAME, '-', LASTNAME))
        
    END AS "URL",

    "PlayerId"
FROM TEMP_LINK AS TL
JOIN "LastNameFirst" AS L ON TL."PlayerId"=L."PlayerId" ;

-- ------------------------------------------------------------------------------

/* Merging downloaded files with birth dates and creating a table with player ID and birth date:

Players with a date of birth greater than 2012 have been excluded, because such dates of birth are probably not filled in correctly 
(There was a real gap in the data between 2013 and 2016. Players born since 2017 would be 6 years old or younger, which is unlikely. 
There were also players born in 2023 in the data, which doesn't really make sense, and it is a misfilled data.) 

Dates of Birth witch were not filled (or 'unknown'), were excluded.
*/

CREATE OR REPLACE TABLE PlayerDOB AS
SELECT * FROM
    (
    SELECT 
        "PlayerId", 
        TO_DATE("DateOfBirth", 'MMMM DD, YYYY') as "DateOfBirth", 
        YEAR(TO_DATE("DateOfBirth", 'MMMM DD, YYYY')) as "Year"
    FROM
        (
        SELECT "Url", "DateOfBirth"
        FROM "DateOfBirth1"
            UNION
        SELECT "Url", "DateOfBirth"
        FROM "DateOfBirth2"
            UNION
        SELECT "Url", "DateOfBirth"
        FROM "DateOfBirth3"
            UNION
        SELECT "Url", "DateOfBirth"
        FROM "DateodBirth4"
            UNION
        SELECT "Url", "DateOfBirth"
        FROM "DateodBirth5"
            UNION
        SELECT "Url", "DateOfBirth"
        FROM "DateodBirth6"
            UNION
        SELECT "Url", "DateOfBirth"
        FROM "DateodBirth7"
            UNION
        SELECT "Url", "DateOfBirth"
        FROM "DateOfBirth08"
            UNION
        SELECT "Url", "DateOfBirth"
            FROM "DateOfBirth09"
        UNION
        SELECT "Url", "DateOfBirth"
        FROM "DateOfBirth10"
            UNION
        SELECT "Url", "DateOfBirth"
        FROM "DateOfBirth_errors_1"
            UNION
        SELECT "Url", "DateOfBirth"
        FROM "DateOfBirth_errors_2"
        )
    JOIN PLAYER_URL p ON "Url"="URL"
    WHERE "DateOfBirth" NOT IN ('<unknown>', '') AND "DateOfBirth" is not null 
    )
WHERE "Year" <= 2012;