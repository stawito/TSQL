WITH sprawa
AS(
SELECT [SprawaId]
      ,[WniosekId]
      ,[StatusSprawyId]
      ,[StatusData]
      ,[OsobaProwadzacaLogin]
      ,[TjoProwadzaceKod]
      ,[Uwaga]
      ,[DataUdzieleniaOdpowiedzi]
      ,[StatusLoginOperatora]
      ,[DataZakonczenia]
  FROM [ROSU2].[Sprawy].[Sprawa] 
  WHERE [StatusSprawyId] ='3') ,
  
  formularz
  AS
  (
  SELECT [FormularzA1Id]
      ,[WniosekId]
      ,[SprawaId]
      ,[PodstawaPrawnaId]
      ,[ZakonczenieId]
      ,[PrzekazanieTjoId]
      ,[SposobZalatwieniaSprawyId]
      ,[DataOd]
      ,[DataDo]
      ,[Par24]
      ,[Par25]
      ,[Par26]
      ,[NazwaPracodawcyZagr]
      ,[AdresPracodawcyZagr]
      ,[BrakStalegoAdresuPracy]
  FROM [ROSU2].[ObslugaSpraw].[FormularzA1]
  where [SposobZalatwieniaSprawyId] = '1' AND 
        cast([DataDo] as date) >= '2019-03-31'
  ) ,

  wniosek
  AS
  (
  SELECT [WniosekId]
      ,[RodzajWnioskuId]
      ,[DataWplywu]
      ,[TjoWplywu]
      ,[PanstwoId]
      ,[InstytucjaId]
      ,[OsobaId]
      ,[PlatnikId]
      ,[SprawaId]
      ,[DataOstatniejModyfikacji]
      ,[OsobaModyfikujaca]
      ,[Lp]
      ,[LpRok]
      ,[DataRejestracji]
  FROM [ROSU2].[Sprawy].[Wniosek]
  ) ,

  osoba
  AS
  (
SELECT [OsobaId]
      ,[Nazwisko]
      ,[NazwiskoRodowe]
      ,[Imie]
      ,[Imie2]
      ,[Pesel]
      ,[Nip]
      ,[RodzajDokumentu]
      ,[NumerDokumentu]
      ,[Email]
      ,[DataUrodzenia]
      ,[MiejsceUrodzenia]
      ,[Plec]
      ,[ObywatelstwoKod]
      ,[_Lp]
      ,[_RodzajFormularza]
      ,[ZUlica]
      ,[ZNrUlicy]
      ,[ZNrLokalu]
      ,[ZKodPocztowy]
      ,[ZMiasto]
      ,[ZSkrytkaPocztowa]
      ,[ZGmina]
      ,[ZPowiat]
      ,[ZWojewodztwo]
      ,[ZKraj]
      ,[PUlica]
      ,[PNrUlicy]
      ,[PNrLokalu]
      ,[PKodPocztowy]
      ,[PMiasto]
      ,[PSkrytkaPocztowa]
      ,[PGmina]
      ,[PPowiat]
      ,[PWojewodztwo]
      ,[PKraj]
  FROM [ROSU2].[Ewidencja].[Osoba]
  ) ,
  platnik
  AS
  (
  SELECT [PlatnikId]
      ,[PlatnikKsiId]
      ,[TypPlatnikaId]
      ,[Nazwa]
      ,[NazwaSkrocona]
      ,[Nazwisko]
      ,[Imie]
      ,[Nip]
      ,[Pesel]
      ,[Regon]
      ,[Pkd]
      ,[PkdCyfry]
      ,[Ulica]
      ,[NrUlicy]
      ,[NrLokalu]
      ,[KodPocztowy]
      ,[Miasto]
      ,[SkrytkaPocztowa]
      ,[Gmina]
      ,[Powiat]
      ,[Wojewodztwo]
      ,[Kraj]
  FROM [ROSU2].[Ewidencja].[Platnik]
  ) ,
  
  wynik
  AS
    (
   Select  o.[Imie] as [Imiê]
         ,o.[Imie2] as [Drugie imiê]
		 ,o.[Nazwisko] as [Nazwisko]
		 ,o.[Pesel] as [Pesel]
		 ,o.[DataUrodzenia] as [Data urodzenia]
		 ,o.[Plec] as [P³eæ]
		 ,o.[ZKraj] as [Obywatelstwo]
		 ,o.[MiejsceUrodzenia] as [Miejsce urodzenia]

		 ,f.[DataOd] as [Poczatek okresu rozliczenia]
         ,f.[DataDo] as [Koniec okresu rozliczenia]
		 ,[Status prawny] = Case p.[TypPlatnikaId] 
								when '1' then 'Pracownik najemny'
		                        else 'Dzia³alnoœæ na w³asny rachunek'
							end
		 ,p.[Pkd] as [Rodzaj dzia³alnoœci]
		 ,o.[PKraj] as [Kraj]
		 ,o.[PKodPocztowy] as [Kod kraju]
		 ,o.[PWojewodztwo] as [Wojewodztwo]
		 ,o.[PPowiat] as [Powiat]
		 ,o.[PGmina] as [Gmina]
		 ,o.[PMiasto] as [Miejscowoœæ]
		 ,o.[PKodPocztowy] as [Kod pocztowy]
		 ,o.[PUlica] as [Nazwa ulicy]
         ,o.[PNrUlicy] as [Numer budynku]
         ,o.[PNrLokalu] as [Numer lokalu]
         ,o.[PSkrytkaPocztowa] as [Skrytka pocztowa]
		 ,f.[WniosekId] as [WniosekId]
         ,f.[SprawaId] as [SprawaId]
  From 
      ( 
        (
         (
         sprawa s join formularz f
         on s.[SprawaId] = f.[SprawaId] and
            s.[WniosekId] = f.[WniosekId]
		  ) join wniosek w
	        on s.[SprawaId] = w.[SprawaId] and
               s.[WniosekId] = w.[WniosekId]
		) join osoba o
		  on w.[OsobaId] = o.[OsobaId]
	 ) join platnik p
	   on w.[PlatnikId] = p.[PlatnikId]
  ) ,
panstwo
As
(
SELECT pwp.[WniosekId]
      ,pwp.[SprawaId]
      ,pwp.[PanstwoKod]
	  ,pan.[Nazwa]
 FROM [ROSU2].[ObslugaSpraw].[PanstwoWykonywaniaPracy] as pwp left join [ROSU2].[Slowniki].[Panstwo] as pan
 on pwp.[PanstwoKod] = pan.[PanstwoKod]
)

 Select 
          [Imiê]
         ,[Drugie imiê]
		 ,[Nazwisko]
		 ,[Pesel]
		 ,[Data urodzenia]
		 ,[P³eæ]
		 ,[Obywatelstwo]
		 ,[Miejsce urodzenia]
		 ,p.[Nazwa] as [Kraj docelowy]
		 ,[Poczatek okresu rozliczenia]
         ,[Koniec okresu rozliczenia]
		 ,[Status prawny] 
		 ,[Rodzaj dzia³alnoœci]
		 ,ISNULL([Kraj],'') as [Kraj]
		 ,[Kod kraju]
		 ,[Wojewodztwo]
		 ,[Powiat]
		 ,[Gmina]
		 ,[Miejscowoœæ]
		 ,[Kod pocztowy]
		 ,[Nazwa ulicy]
         ,[Numer budynku]
         ,[Numer lokalu]
         ,[Skrytka pocztowa]
		 ,w.[WniosekId]
         ,w.[SprawaId] 
 from wynik as w join panstwo as p
 on w.[WniosekId] = p.[WniosekId] and 
    w.[SprawaId] = p.[SprawaId]
order by WniosekId, SprawaId

   