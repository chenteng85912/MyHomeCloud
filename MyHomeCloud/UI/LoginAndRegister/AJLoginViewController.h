

typedef void (^CallBackBlock)(void);

@interface AJLoginViewController : UIViewController

@property (strong, nonatomic) CallBackBlock backBlock;

@end
