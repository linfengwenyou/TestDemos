# NumberUtil

### 效果如图

```
NSNumber *number = [NSNumber numberWithDouble:999.2255555];

NSLog(@"%@",number.roundDown(5));

NSLog(@"%@",number.roundUp(5));

NSLog(@"%@",number.roundPlain(5));

NSLog(@"%@",number.roundBanker(2));

2019-06-04 23:21:12.670106+0800 DemoDecimal[4027:183079] 999.22555
2019-06-04 23:21:12.670191+0800 DemoDecimal[4027:183079] 999.22556
2019-06-04 23:21:12.670242+0800 DemoDecimal[4027:183079] 999.22556
2019-06-04 23:21:12.670279+0800 DemoDecimal[4027:183079] 999.23

```

