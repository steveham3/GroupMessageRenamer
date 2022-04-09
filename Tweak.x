#include <UIKit/UIKit.h>

@interface UIContextMenuConfiguration (Private)
@property (nonatomic, copy) UIContextMenuActionProvider actionProvider;
@end

@interface CKConversation : NSObject
-(NSString *)displayName;
-(void)setDisplayName:(NSString *)arg1;
-(BOOL)isGroupConversation;
@end

@interface CKConversationListCollectionViewController : UICollectionViewController
-(CKConversation*)conversationAtIndexPath:(NSIndexPath*)path;
@end

%hook CKConversationListCollectionViewController

-(UIContextMenuConfiguration*)collectionView:(UICollectionView*)view contextMenuConfigurationForItemAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point {
    UIContextMenuConfiguration* config = %orig();

    CKConversation* conversation = [self conversationAtIndexPath:indexPath];
    
    if ([conversation isGroupConversation]) {
        UIContextMenuActionProvider originalBlock = config.actionProvider;

        config.actionProvider = ^UIMenu*(NSArray<UIMenuElement*>* actions) { 
            UIMenu* actionMenu = originalBlock(actions);
            NSMutableArray* children = [NSMutableArray arrayWithArray:actionMenu.children];

            UIAction* renameAction = [UIAction actionWithTitle:@"Change Group Name" image:nil identifier:nil handler:^(UIAction* action) {
                    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"New Group Name" message:@"Leave blank to remove the name" preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addTextFieldWithConfigurationHandler:nil];
                    alertController.textFields[0].text = [conversation displayName];

                    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];

                    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* alertAction){
                        UITextField* textField = alertController.textFields[0];
                        [conversation setDisplayName:textField.text];
                        [self.collectionView reloadData];
                    }]];

                    [self presentViewController:alertController animated:YES completion:nil];
            }];

            [children addObjectsFromArray:@[renameAction]];
            return [actionMenu menuByReplacingChildren:children];
        };
    }

    return config;
}

%end


