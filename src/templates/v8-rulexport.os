#Использовать rulexport
#Использовать gitrunner

Перем ПапкаРаспаковки;
Перем Схема;

Процедура ВыполнитьДействие()

	ТекущийКаталог = ТекущийКаталог();
	КаталогЭкспорта = ОбъединитьПути(ТекущийКаталог, ПапкаРаспаковки);

	// получить схему
	Схема = ОбъединитьПути(ТекущийКаталог, Схема);

	РазборПравил = Новый РазборПравил(Схема);

	// получить файлы в индексе
	ГитРепозиторий = Новый ГитРепозиторий();
	ГитРепозиторий.УстановитьРабочийКаталог(ТекущийКаталог);
	
	ДанныеСтатуса = ГитРепозиторий.ДанныеСтатуса();

	ФайлыКУдалению = ДанныеСтатуса.КУдалению();
	Для каждого ИмяФайла Из ФайлыКУдалению Цикл
		Файл = Новый Файл(ИмяФайла);
		Если СтрНачинаетсяС(ИмяФайла, ПапкаРаспаковки) Тогда
			Продолжить;
		КонецЕсли;
		ПапкаПравил = ОбъединитьПути(КаталогЭкспорта, Файл.Путь, Файл.ИмяБезРасширения);
		Попытка
			УдалитьФайлы(ПапкаПравил);
		Исключение
			Сообщить("Ошибка удаления файла (папки): '" + ПапкаПравил + "'");
		КонецПопытки;
	КонецЦикла;

	ФайлыКДобавлению = ДанныеСтатуса.КДобавлению();
	ФайлыВнеИндекса = ДанныеСтатуса.ВнеИндекса();
	мФайлыКД2 = Новый Массив;
	Для каждого ИмяФайла Из ФайлыКДобавлению Цикл
		Если СтрНачинаетсяС(ИмяФайла, ПапкаРаспаковки) Тогда
			Продолжить;
		КонецЕсли;

		Если Нрег(Прав(ИмяФайла, 4)) = ".xml"
			И РазборПравил.ЭтоФайлКД2(ИмяФайла) Тогда
			
			Если ФайлыВнеИндекса.Найти(ИмяФайла) <> Неопределено Тогда
				ВызватьИсключение СтрШаблон("Файл %1 модифицирован и не добавлен в индекс", ИмяФайла);
			Иначе
				мФайлыКД2.Добавить(ИмяФайла);
			КонецЕсли;
		КонецЕсли;

	КонецЦикла;

	Если ЗначениеЗаполнено(мФайлыКД2) Тогда

		Сообщить("Экспорт правил начат в " + ТекущаяДата());
	 
		Для каждого ИмяФайла Из мФайлыКД2 Цикл
			Сообщить("Разбор файла: " + ИмяФайла);
			Файл = Новый Файл(ИмяФайла);
			// хвост с именем файла добавляется в классе РазборПравил
			ПапкаПравил = ОбъединитьПути(КаталогЭкспорта, Файл.Путь);
			РазборПравил.УстановитьПутьРаспаковки(ПапкаПравил);
			РазборПравил.ВыполнитьЭкспорт(ИмяФайла);
		КонецЦикла;

		ГитРепозиторий.ДобавитьФайлВИндекс(КаталогЭкспорта);

		Сообщить("Экспорт правил завершен в " + ТекущаяДата());
	
	КонецЕсли;

КонецПроцедуры


ПапкаРаспаковки = АргументыКоманднойСтроки[0];
Схема           = АргументыКоманднойСтроки[1];

ВыполнитьДействие();