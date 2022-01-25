#STRATEGY MACDEMAStrategy 1H NO EXECUTE ALL
#CONFIG endOnExecution 0
#DEFINE isFirstRun 0
#DEFINE lastMacd lastMACDObject GLOBAL
#IF lastMacd IS_UNDEFINED THEN SET isFirstRun TO 1
#GET MACD(12,26,9) TO MacdObject
#IF lastMacd IS_UNDEFINED THEN SET_GLOBAL lastMACDObject TO MacdObject
#IF isFirstRun EQUAL 1 THEN BREAK

#GLOBAL lastMACDObject MacdObject
#DEFINE conditions 0 NUMBER
#GET EMA(200) TO TrendEMA
#GET CANDLE(0) TO lastClosedCandle
#IF lastClosedCandle.close BELOW TrendEMA SKIPTO ::ShortSetup
#IF lastClosedCandle.close ABOVE TrendEMA SKIPTO ::LongSetup

::ShortSetup
#IF lastMacd.MACD ABOVE 0.0 THEN ADDTO conditions
#IF lastMacd.signal ABOVE 0.0 THEN ADDTO conditions
#IF lastMacd.historgram ABOVE 0.0 THEN ADDTO conditions
#IF MacdObject.historgram BELOW 0.0 THEN ADDTO conditions

#CALC TrendEMA SUBTRACT lastClosedCandle.close TO StopLoss
#CALC StopLoss DEVIDE 4 TO 1stTargetAddition
#CALC 1stTargetAddition MULTIPLE 2 TO 2ndTargetAddtion
#CALC 1stTargetAddition MULTIPLE 3 TO 3rdTargetAddtion
#CALC 1stTargetAddition MULTIPLE 4 TO 4thTargetAddtion

#CALC lastClosedCandle.close SUBTRACT 1stTargetAddition TO TP1
#CALC lastClosedCandle.close SUBTRACT 2ndTargetAddtion TO TP2
#CALC lastClosedCandle.close SUBTRACT 3rdTargetAddtion TO TP3
#CALC lastClosedCandle.close SUBTRACT 4thTargetAddtion TO TP4

#ORDER MacdStraShort SHORT ENTRY lastClosedCandle.close TP TP1 TP2 TP3 TP4 SL StopLoss
BREAK

::LongSetup
#IF lastMacd.MACD BELOW 0.0 THEN ADDTO conditions
#IF lastMacd.signal BELOW 0.0 THEN ADDTO conditions
#IF lastMacd.historgram BELOW 0.0 THEN ADDTO conditions
#IF MacdObject.historgram ABOVE 0.0 THEN ADDTO conditions

#CALC lastClosedCandle.close SUBTRACT TrendEMA TO StopLoss
#CALC StopLoss DEVIDE 4 TO 1stTargetAddition
#CALC 1stTargetAddition MULTIPLE 2 TO 2ndTargetAddtion
#CALC 1stTargetAddition MULTIPLE 3 TO 3rdTargetAddtion
#CALC 1stTargetAddition MULTIPLE 4 TO 4thTargetAddtion

#CALC lastClosedCandle.close SUM 1stTargetAddition TO TP1
#CALC lastClosedCandle.close SUM 2ndTargetAddtion TO TP2
#CALC lastClosedCandle.close SUM 3rdTargetAddtion TO TP3
#CALC lastClosedCandle.close SUM 4thTargetAddtion TO TP4

#ORDER MacdStraShort LONG ENTRY lastClosedCandle.close TP TP1 TP2 TP3 TP4 SL StopLoss
BREAK