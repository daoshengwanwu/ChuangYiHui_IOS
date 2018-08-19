#import "CY51CTOCourseListController.h"


@interface CY51CTOCourseListController ()

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * courseArray;

@end


@implementation CY51CTOCourseListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self get51CTOCourseListFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView {
    
}

- (void)get51CTOCourseListFromServer {
    
}

@end
