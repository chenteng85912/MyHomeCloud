

typedef void (^CallBackBlock)(void);

@interface AJLoginViewController : CTBaseViewController

@property (strong, nonatomic) CallBackBlock backBlock;

@end
