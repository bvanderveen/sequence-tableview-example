#import "SequenceTableController.h"
#import "Sequence.h"

@interface TableItem : NSObject {
    UITableViewCell *(^cell)();
    void (^action)();
}

@property (nonatomic, copy) UITableViewCell *(^cell)();
@property (nonatomic, copy) void (^action)();

@end

@implementation TableItem

@synthesize cell, action;

- (void)dealloc {
    self.cell = nil;
    self.action = nil;
    [super dealloc];
}

@end

@interface SequenceTableController ()

@property (nonatomic, retain) id content;

@end

@implementation SequenceTableController

@synthesize content;

- (UITableViewCell *)cellWithLabelText:(NSString *)labelText {
    static NSString *ident = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    
    if (!cell)
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident] autorelease];
    
    cell.textLabel.text = labelText;
    
    return cell;
}

- (void)alertText:(NSString *)text {
    [[[[UIAlertView alloc] initWithTitle:nil message:text delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] autorelease] show];
}

- (id)init {
    if ((self = [super initWithNibName:nil bundle:nil])) {
        self.content = [[[[Seq rangeWithStart:1 end:20000]
            filter:^ BOOL (id n) { 
                return [n intValue] % 5 == 0; 
            }] 
            map:^ id (id n) {
                NSString *s = [n description];
                TableItem *item = [[TableItem new] autorelease];
                item.cell = [[^ id () { return [self cellWithLabelText:s]; } copy] autorelease];
                item.action = [[^ void () { [self alertText:s]; } copy] autorelease];
                return item;
            }] array];
    }
    return self;
}

- (void)dealloc {
    self.content = nil;
    [super dealloc];
}

- (void)loadView {
    tableView = [[[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.view = tableView;
}

- (void)viewDidUnload {
    tableView = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return content.count; 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableItem *item = [content objectAtIndex:indexPath.row];
    return item.cell();
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TableItem *item = [content objectAtIndex:indexPath.row];
    item.action();
}

@end
