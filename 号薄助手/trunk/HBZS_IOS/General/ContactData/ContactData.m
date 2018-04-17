//
//  ContactData.m
//  CTPIM
//
//  Created by  Kevin Zhang、Kevin Zhang、 scanmac on 11-9-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ContactData.h"

#import "HBZSAppDelegate.h"
#import "GobalSettings.h"
#import "MyString.h"
#import "NameIndex.h"
#import "ChineseToPinYin.h"
#import "Public.h"

@implementation ContactData

/*
 * 获取通讯录联系人个数
 */
+ (NSInteger)getAllContactsCount{
    NSInteger result = 0;
    
    HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    ABAddressBookRef addressBookRef = delegate.getAddressBookRef;
    
    if (nil == addressBookRef) {
        ZBLog(@"getAllContactsCount,addressBookRef == nil......");
        return result;
    }
    
    CFArrayRef allContacts = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    
    if (nil == allContacts) {
        ZBLog(@"getAllContactsCount,allContacts == nil......");
        
        return result;
    }
    
    result = (NSUInteger)CFArrayGetCount(allContacts);
    
    if (nil != allContacts){
        CFRelease(allContacts);
        
        allContacts = nil;
    }
    
    return result;
}

+ (NSMutableArray*)getAllContactMembers{
    HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication]delegate];
    ABAddressBookRef addressBookRef = delegate.getAddressBookRef;
    
    if (addressBookRef == nil) {
        ZBLog(@"getAllContactMembers,addressBookRef == nil");
        return nil;
    }
    
    NSMutableArray *mutableArray = nil;
    
    ABMutableMultiValueRef phoneMulti = nil;
    
    CFArrayRef allContacts = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    
    if (nil == allContacts) {
        ZBLog(@"getAllContactMembers allContacts is nil");
        goto ERROR;
    }
    
    mutableArray = [NSMutableArray arrayWithCapacity:(NSUInteger)CFArrayGetCount(allContacts)];
    
    ABRecordID recId;
    
    for (id contact in (NSArray *) allContacts)
    {
        ContactMember *contactMember = [[ContactMember alloc] init];
        //名字
        NSString *firstname = nil;
        
        NSString *lastname = nil;
        
        firstname = (NSString *)ABRecordCopyValue(contact, kABPersonFirstNameProperty);
        lastname = (NSString *)ABRecordCopyValue(contact, kABPersonLastNameProperty);
        
        if(lastname != nil && firstname != nil){
            contactMember.name =  [NSString stringWithFormat:@"%@ %@",lastname,firstname];
        }
        else if(lastname != nil){
            contactMember.name = [NSString stringWithFormat:@"%@",lastname];
        }
        else if(firstname != nil){
            contactMember.name =  [NSString stringWithFormat:@"%@",firstname];
        }
        //号码
        phoneMulti = ABRecordCopyValue(contact, kABPersonPhoneProperty);
        
        for (int i = 0;  i < ABMultiValueGetCount(phoneMulti);  i++){
            NSString *phone = (NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, i);
            
            contactMember.phone = phone;
            
            break;
        }
        
        if (nil != phoneMulti){
            CFRelease(phoneMulti);
            
            phoneMulti = nil;
        }
        
        if (firstname) {
            [firstname release];
        }
        
        if (lastname) {
            [lastname release];
        }
        //ID
        recId = ABRecordGetRecordID(contact);
        
        contactMember.ID = (NSUInteger)recId;
        
        [mutableArray addObject:contactMember];
        
        [contactMember release];
    }
    
ERROR:
    
    if (nil != phoneMulti){
        CFRelease(phoneMulti);
        
        phoneMulti = nil;
    }
    
    if (nil != allContacts){
        CFRelease(allContacts);
        
        allContacts = nil;
    }
    
    return mutableArray;
}

+ (NSMutableArray*) getGroupAllContactMembers:(NSUInteger) groupID{
    return nil;
}

+ (ABRecordRef)getRecordByID:(NSUInteger) recordID{
    HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    ABAddressBookRef addressBookRef = delegate.getAddressBookRef;
    ABRecordRef personRef = nil;
    
    if (nil == addressBookRef) {
        ZBLog(@"getRecordByID addressBookRef is nil");
        return nil;
    }
    
    personRef = ABAddressBookGetPersonWithRecordID(addressBookRef, recordID);
    
    if (nil == personRef){
        ZBLog(@"getRecordByID personRef is nil");
        
        return nil;
    }
    
    return personRef;
}

/*
 * 获取联系人头像
 */
+ (CFDataRef) getPersonImageByID:(NSUInteger) personID
{
    HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication]delegate];
	ABAddressBookRef addressBookRef = delegate.getAddressBookRef;
    
    CFDataRef cfDataRef = nil;
    
    if (nil == addressBookRef) {
        ZBLog(@"getPersonImageByID addressBookRef is nil");
        return nil;
    }
    
    ABRecordRef personRef = ABAddressBookGetPersonWithRecordID(addressBookRef, personID);
    
    if (nil == personRef){
        ZBLog(@"getPersonImageByID personRef is nil");
        goto ERROR;
    }
    
    cfDataRef = ABPersonCopyImageDataWithFormat(personRef, 0);
    
    if (nil == cfDataRef) {
        goto ERROR;
    }
    
    if (cfDataRef) {
        CFRelease(cfDataRef);
    }
    
ERROR:
    
    return cfDataRef;
}

+ (NSString*) getPersonNameByID:(NSUInteger) personID{
    NSString *str = nil;
    
    HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    ABAddressBookRef addressBookRef = delegate.getAddressBookRef;
    
    if (nil == addressBookRef) {
        ZBLog(@"getPersonNameByID addressBookRef is nil");
        goto ERROR;
    }
    
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBookRef, personID);
    
    if (nil == person) {
        ZBLog(@"getPersonNameByID person is nil");
        goto ERROR;
    }
    
	NSString *firstname = nil;
    NSString *lastname = nil;
    
	// name
	firstname = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    
    lastname = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    
    if(lastname != nil && firstname != nil)
    {
        str =  [NSString stringWithFormat:@"%@ %@",lastname,firstname];
    }else if(lastname != nil)
    {
        str = [NSString stringWithFormat:@"%@",lastname];
    }else if(firstname != nil)
    {
        str =  [NSString stringWithFormat:@"%@",firstname];
    }
    
    if (firstname) {
        [firstname release];
    }
    
    if (lastname) {
        [lastname release];
    }
    
ERROR:
    
    if (nil == str)
        str = @"";
    
    return str;
}

+ (NSInteger) getRecordIDByPhone:(NSString*) phoneStr{
    if (phoneStr == nil || [phoneStr length] <= 0){
        return -1;
    }

    HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication]delegate];
    ABAddressBookRef addressBookRef = delegate.getAddressBookRef;
    
    NSInteger recordID = -1;
    
    ABMutableMultiValueRef phoneMulti = nil;
    
    if (nil == addressBookRef) {
        ZBLog(@"getRecordIDByPhone addressBookRef is nil");
        return -1;
    }
    
    CFArrayRef allContacts = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    
    if (nil == allContacts) {
        ZBLog(@"getRecordIDByPhone allContacts is nil");
        goto ERROR;
    }
    
    for (id contact in (NSArray *) allContacts)
    {
        //号码
        phoneMulti = ABRecordCopyValue(contact, kABPersonPhoneProperty);
        
        for (int i = 0;  i < ABMultiValueGetCount(phoneMulti);  i++) {
            NSMutableString *phone = [(NSMutableString*)ABMultiValueCopyValueAtIndex(phoneMulti, i) autorelease];
            
            NSMutableString *phone1 = [[NSMutableString alloc] initWithString:phone];

            
            if ([phone1 isEqualToString:phoneStr]) {
                recordID = ABRecordGetRecordID(contact);
                
                [phone1 release];
                
                goto ERROR;
            }
            
            if (phone1) {
                [phone1 release];
            }
        }
        
        if (nil != phoneMulti) {
            CFRelease(phoneMulti);
            
            phoneMulti = nil;
        }
    }
    
ERROR:
    
    if (nil != phoneMulti) {
        CFRelease(phoneMulti);
        
        phoneMulti = nil;
    }
    
    if (nil != allContacts){
        CFRelease(allContacts);
        allContacts = nil;
    }
    
    return recordID;
}

+ (NSString*) getRecordPhoneByID:(NSInteger) personID{
    HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	ABAddressBookRef addressBookRef = delegate.getAddressBookRef;
        
    NSString* strPhone = nil;
    
    ABMutableMultiValueRef phoneMulti = nil;
    
    if (nil == addressBookRef) {
        ZBLog(@"getRecordPhoneByID addressBookRef is nil");
        return nil;
    }
    
    ABRecordRef recordRef = ABAddressBookGetPersonWithRecordID(addressBookRef, personID);
    
    if (recordRef == nil) {
        ZBLog(@"getRecordPhoneByID recordRef is nil");
        goto ERROR;
    }
    
    //号码
    phoneMulti = ABRecordCopyValue(recordRef, kABPersonPhoneProperty);
    
    for (int i = 0;  i < ABMultiValueGetCount(phoneMulti);  i++) {
        strPhone = [(NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, i) autorelease];
        
        break;
    }
    
ERROR:
    
    if (nil != phoneMulti){
        CFRelease(phoneMulti);
        
        phoneMulti = nil;
    }
    
    return strPhone;
}

+ (NSString*) getRecordEmailByID:(NSInteger) personID{
    HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    ABAddressBookRef addressBookRef = delegate.getAddressBookRef;
    
    NSString* strEmail = nil;
    
    ABMutableMultiValueRef EmailMulti = nil;
    
    if (nil == addressBookRef) {
        ZBLog(@"getRecordEmailByID addressBookRef is nil");
        return nil;
    }
    
    ABRecordRef recordRef = ABAddressBookGetPersonWithRecordID(addressBookRef, personID);
    
    if (recordRef == nil) {
        ZBLog(@"getRecordEmailByID recordRef is nil");
        goto ERROR;
    }
    
    //Email
    EmailMulti = ABRecordCopyValue(recordRef, kABPersonEmailProperty);

    for (int i = 0;  i < ABMultiValueGetCount(EmailMulti);  i++) {
        NSString *label = (NSString *)ABMultiValueCopyLabelAtIndex(EmailMulti, i);
        
        if([label isEqualToString:@"QQ"] || [label isEqualToString:@"MSN"] ||[label isEqualToString:@"gender"]||[label isEqualToString:@"constellation"] ||[label isEqualToString:@"bloodType"]){
           
            if (label) {
                [label release];
                label = nil;
            }
            
            continue;
        }
        
        strEmail = [(NSString*)ABMultiValueCopyValueAtIndex(EmailMulti, i) autorelease];
        
        if (label) {
            [label release];
            label = nil;
        }
        
        break;
    }
    
ERROR:
    
    if (nil != EmailMulti){
        CFRelease(EmailMulti);
        
        EmailMulti = nil;
    }
    
    return strEmail;
}

+ (NSString*) getRecordCompnyByID:(NSInteger) personID{
    HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    ABAddressBookRef addressBookRef = delegate.getAddressBookRef;
    
    if (nil == addressBookRef) {
        ZBLog(@"getRecordCompnyByID addressBookRef is nil");
        return nil;
    }
    
    ABRecordRef recordRef = ABAddressBookGetPersonWithRecordID(addressBookRef, personID);
    
    if (recordRef == nil) {
        ZBLog(@"getRecordCompnyByID recordRef is nil");

        return nil;
    }
    
    NSString* strCompny = nil;
	//
	strCompny = [(NSString *)ABRecordCopyValue(recordRef, kABPersonOrganizationProperty) autorelease];
    
    NSString *temp = strCompny;
    
    return temp;
}

+ (NSMutableArray*) getAllRecordOnePhone{
    ABAddressBookRef addressBookRef = nil;
    
    addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        //等待同意后向下执行
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
    ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_semaphore_signal(sema);
                                                 });
        
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    dispatch_release(sema);
    
    
    NSMutableArray *mutableArray = nil;
    
    ABMutableMultiValueRef phoneMulti = nil;
    
    if (nil == addressBookRef) {
        ZBLog(@"getAllRecordOnePhone addressBookRef is nil");
        return nil;
    }
    
    CFArrayRef allContacts = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    
    if (nil == allContacts) {
        ZBLog(@"getAllRecordOnePhone allContacts is nil");
        goto ERROR;
    }
    
    mutableArray = [[[NSMutableArray alloc]init]autorelease];
    
    for (id contact in (NSArray *) allContacts)
    {
        //号码
        phoneMulti = ABRecordCopyValue(contact, kABPersonPhoneProperty);
        
        for (int i = 0;  i < ABMultiValueGetCount(phoneMulti);  i++) {
            NSString *phone = [(NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, i) autorelease];
            ZBLog(@"phone[%@]", phone);
            [mutableArray addObject:phone];
            break;
        }
        
        if (nil != phoneMulti){
            CFRelease(phoneMulti);
            
            phoneMulti = nil;
        }
    }
    
ERROR:
    
    if (nil != phoneMulti){
        CFRelease(phoneMulti);
        
        phoneMulti = nil;
    }
    
    if (nil != allContacts){
        CFRelease(allContacts);
        
        allContacts = nil;
    }
    
    CFRelease(addressBookRef);
    
    return mutableArray;
}

+ (NSMutableArray*) getAllRecordOneEmail{
    ABAddressBookRef addressBookRef = nil;
    
    addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_semaphore_signal(sema);
                                                 });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        dispatch_release(sema);

    NSMutableArray *mutableArray = nil;
    
    ABMutableMultiValueRef phoneMulti = nil;
    
    if (nil == addressBookRef) {
        ZBLog(@"getAllRecordOneEamil addressBookRef is nil");
        return nil;
    }
    
    CFArrayRef allContacts = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    
    if (nil == allContacts) {
        ZBLog(@"getAllRecordOneEamil allContacts is nil");
        goto ERROR;
    }
    
    mutableArray = [[[NSMutableArray alloc]init]autorelease];
    
    for (id contact in (NSArray *) allContacts)
    {
        //号码
        phoneMulti = ABRecordCopyValue(contact, kABPersonEmailProperty);
        
        for (int i = 0;  i < ABMultiValueGetCount(phoneMulti);  i++) {
            NSString *Email = [(NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, i) autorelease];
           // ZBLog(@"Email[%@]", Email);
            [mutableArray addObject:Email];
            
            break;
        }
        
        if (nil != phoneMulti){
            CFRelease(phoneMulti);
            
            phoneMulti = nil;
        }
    }
    
ERROR:
    
    if (nil != phoneMulti){
        CFRelease(phoneMulti);
        
        phoneMulti = nil;
    }
    
    if (nil != allContacts){
        CFRelease(allContacts);
        
        allContacts = nil;
    }
    
    if (addressBookRef) {
        CFRelease(addressBookRef);
    }
    
    return mutableArray;
}

+ (BOOL) deleteContactByID:(NSInteger) personID{
    HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    ABAddressBookRef addressBookRef = delegate.getAddressBookRef;
    
    BOOL bSuccess = NO;
    
    if (nil == addressBookRef) {
        ZBLog(@"deleteContactByID addressBookRef is nil");
        return NO;
    }
    
    ABRecordRef personRef = ABAddressBookGetPersonWithRecordID(addressBookRef, personID);
    
    if (nil == personRef){
        ZBLog(@"deleteContactByID personRef is nil");
        goto ERROR;
    }
    
    bSuccess = ABAddressBookRemoveRecord(addressBookRef, personRef, nil);
    
    if (bSuccess){
        ABAddressBookSave(addressBookRef, nil);
    }
    
ERROR:
    
    return bSuccess;
    
}

+ (BOOL) deleteContacts:(NSMutableArray*) mutableArray{
    if (mutableArray == nil || [mutableArray count] <= 0) {
        return YES;
    }
    
    HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    ABAddressBookRef addressBookRef = delegate.getAddressBookRef;
    
    BOOL bSuccess = YES;
    
    if (nil == addressBookRef) {
        ZBLog(@"deleteContacts addressBookRef is nil");
        return NO;
    }
    
    ZBLog(@"要删除联系人个数[%d]", [mutableArray count]);
    
    for (NSInteger i = 0; i < [mutableArray count]; i++) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
        
        NSString *str = [mutableArray objectAtIndex:i];
        
        ABRecordID personID = [str integerValue];
        
        ABRecordRef personRef = ABAddressBookGetPersonWithRecordID(addressBookRef, personID);
        
        if (nil == personRef){
            ZBLog(@"deleteContacts personRef is nil");
            ABAddressBookRevert(addressBookRef);
            
            bSuccess = NO;
            
            [pool release];
            
            return bSuccess;
        }
        
        bSuccess = ABAddressBookRemoveRecord(addressBookRef, personRef, nil);
        
        if (!bSuccess){
            ZBLog(@"批量删除联系人失败");
            ABAddressBookRevert(addressBookRef);
            
            bSuccess = NO;
            
            [pool release];
            
            return bSuccess;
        }
        
        [pool release];
        
        //ZBLog(@"已删除联系人个数[%d]/[%d]",i+1,[mutableArray count]);
    }
    
ERROR:
    ABAddressBookSave(addressBookRef, nil);
    
    return bSuccess;
}

+ (BOOL) addGroupContacts:(NSInteger) groupID array:(NSMutableArray*) mutableArray{
    HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    ABAddressBookRef addressBookRef = delegate.getAddressBookRef;
    
    BOOL bSuccess = YES;
    
    if (nil == addressBookRef) {
        ZBLog(@"addGroupContacts addressBookRef is nil");
        return NO;
    }
    
    ZBLog(@"要添加群组的联系人个数[%d]", [mutableArray count]);
    
    ABRecordRef groupRef = ABAddressBookGetGroupWithRecordID(addressBookRef, groupID);
    
    if (nil == groupRef){
        ZBLog(@"addGroupContacts groupRef is nil");
        bSuccess = NO;
        
        goto ERROR;
    }
    
    for (NSInteger i = 0; i < [mutableArray count]; i++) {
        NSString *str = [mutableArray objectAtIndex:i];
        
        ABRecordID personID = [str integerValue];
        
        ABRecordRef personRef = ABAddressBookGetPersonWithRecordID(addressBookRef, personID);
        
        if (nil == personRef){
            ZBLog(@"addGroupContacts personRef is nil");
            bSuccess = NO;
            
            continue;
        }
        
        bSuccess = ABGroupAddMember(groupRef, personRef, nil);
        
        if (!bSuccess){
            ZBLog(@"批量添加群组联系人失败");
            bSuccess = NO;
        }
    }
    
ERROR:
    ABAddressBookSave(addressBookRef, nil);
    
    return bSuccess;
}

+ (BOOL) removeGroupContacts:(NSInteger) groupID array:(NSMutableArray*) mutableArray{
    if (groupID <= 0 || mutableArray == nil || [mutableArray count] <= 0) {
        return YES;
    }
    
    HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    ABAddressBookRef addressBookRef = delegate.getAddressBookRef;
    
    BOOL bSuccess = YES;
    
    if (nil == addressBookRef) {
        ZBLog(@"removeGroupContacts addressBookRef is nil");
        return NO;
    }
    
    ZBLog(@"要移出群组的联系人个数[%d]", [mutableArray count]);
    
    ABRecordRef groupRef = ABAddressBookGetGroupWithRecordID(addressBookRef, groupID);
    
    if (nil == groupRef){
        ZBLog(@"removeGroupContacts groupRef is nil");
        bSuccess = NO;
        
        goto ERROR;
    }
    
    for (NSInteger i = 0; i < [mutableArray count]; i++) {
        NSString *str = [mutableArray objectAtIndex:i];
        
        ABRecordID personID = [str integerValue];
        
        ABRecordRef personRef = ABAddressBookGetPersonWithRecordID(addressBookRef, personID);
        
        if (nil == personRef){
            ZBLog(@"removeGroupContacts personRef is nil");
            bSuccess = NO;
            
            continue;
        }
        
        bSuccess = ABGroupRemoveMember(groupRef, personRef, nil);
        
        if (!bSuccess)
        {
            ZBLog(@"批量移出群组联系人失败");
            bSuccess = NO;
        }
    }
    
ERROR:
    ABAddressBookSave(addressBookRef, nil);
    
    return bSuccess;
}

+ (NSMutableArray*) searchContactStrByNameOrPhone:(NSString*) str{
    ABAddressBookRef addressBookRef = nil;
    
   
        addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_semaphore_signal(sema);
                                                 });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        dispatch_release(sema);
    
    NSMutableArray *mutableArray = nil;
    
    ABMutableMultiValueRef phoneMulti = nil;
    
    if (nil == addressBookRef) {
        ZBLog(@"searchContactStrByNameOrPhone addressBookRef is nil");
        return nil;
    }
    
    CFArrayRef allContacts = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    
    if (nil == allContacts) {
        ZBLog(@"searchContactStrByNameOrPhone allContacts is nil");
        goto ERROR;
    }
    
    mutableArray = [[[NSMutableArray alloc]init]autorelease];
    
    ABRecordID recId;
    
    for (id contact in (NSArray *) allContacts)
    {
        //名字
        NSString *firstname = nil;
        NSString *lastname = nil;
        NSRange range;
        
        firstname = (NSString *)ABRecordCopyValue(contact, kABPersonFirstNameProperty);
        lastname = (NSString *)ABRecordCopyValue(contact, kABPersonLastNameProperty);
        
        range = [firstname rangeOfString:str];
        
        if (range.length > 0 && range.location > 0) {
            recId = ABRecordGetRecordID(contact);
            
            NSString *recIDStr = [NSString stringWithFormat:@"%d", recId];
            
            [mutableArray addObject:recIDStr];
            
            continue;
            
        }
        
        range = [lastname rangeOfString:str];
        
        if (range.length > 0 && range.location > 0) {
            recId = ABRecordGetRecordID(contact);
            
            NSString *recIDStr = [NSString stringWithFormat:@"%d", recId];
            
            [mutableArray addObject:recIDStr];
            continue;
        }
        
        //号码
        phoneMulti = ABRecordCopyValue(contact, kABPersonPhoneProperty);
        
        for (int i = 0;  i < ABMultiValueGetCount(phoneMulti);  i++) {
            NSString *phone = [(NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, i) autorelease];
            
            NSMutableString *phonestr = [[[NSMutableString alloc] initWithString:phone]autorelease];
            
            range = [phonestr rangeOfString:str];
            
            if (range.length > 0){// && range.location > 0) {
                recId = ABRecordGetRecordID(contact);
                
                NSString *recIDStr = [NSString stringWithFormat:@"%d", recId];
                
                [mutableArray addObject:recIDStr];
                break;
                
            }
        }
        
        if (nil != phoneMulti){
            
            CFRelease(phoneMulti);
            
            phoneMulti = nil;
        }
        
        if (firstname) {
            [firstname release];
            lastname = nil;
        }
        
        if (lastname) {
            [lastname release];
            lastname = nil;
        }
    }
    
ERROR:
    
    if (nil != phoneMulti){
        CFRelease(phoneMulti);
        
        phoneMulti = nil;
    }
    
    if (nil != allContacts){
        CFRelease(allContacts);
        
        allContacts = nil;
    }
    
    if (addressBookRef) {
        CFRelease(addressBookRef);
    }
    
    return mutableArray;
}

+ (NSMutableArray*) searchContactStrByPhone:(NSString*) str{
    ABAddressBookRef addressBookRef = nil;
    
   
        addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_semaphore_signal(sema);
                                                 });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        dispatch_release(sema);
    
    NSMutableArray *mutableArray = nil;
    
    ABMutableMultiValueRef phoneMulti = nil;
    
    if (nil == addressBookRef) {
        ZBLog(@"searchContactStrByPhone addressBookRef is nil");
        return nil;
    }
    
    CFArrayRef allContacts = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    
    if (nil == allContacts) {
        ZBLog(@"searchContactStrByPhone allContacts is nil");
        goto ERROR;
    }
    
    mutableArray = [[[NSMutableArray alloc]init]autorelease];
    
    ABRecordID recId;
    
    for (id contact in (NSArray *) allContacts)
    {
        //号码
        NSRange range;
        
        phoneMulti = ABRecordCopyValue(contact, kABPersonPhoneProperty);
        
        for (int i = 0;  i < ABMultiValueGetCount(phoneMulti);  i++) {
            NSString *phone = [(NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, i) autorelease];
            
            NSMutableString *phonestr = [[NSMutableString alloc] initWithString:phone];
            
            range = [phonestr rangeOfString:str];
            
            [phonestr release];
            
            if (range.length > 0){
                DialItem *dialItem = [[DialItem alloc]init];
                
                recId = ABRecordGetRecordID(contact);
                
                dialItem.contactID = recId;
                
                dialItem.phone = phonestr;
                
                NSString *firstname = nil;
                
                NSString *lastname = nil;
                // name
                firstname = (NSString *)ABRecordCopyValue(contact, kABPersonFirstNameProperty);
                
                lastname = (NSString *)ABRecordCopyValue(contact, kABPersonLastNameProperty);
                
                if(lastname != nil && firstname != nil){
                    dialItem.name =  [NSString stringWithFormat:@"%@ %@",lastname,firstname];
                }
                else if(lastname != nil){
                    dialItem.name = lastname;
                }
                else if(firstname != nil){
                    dialItem.name =  firstname;
                }
                
                [mutableArray addObject:dialItem];
                
                [dialItem release];
                
                if (firstname) {
                    [firstname release];
                }
                
                if (lastname) {
                    [lastname release];
                }
                
                break;
            }
        }
        
        if (nil != phoneMulti){
            CFRelease(phoneMulti);
            
            phoneMulti = nil;
        }
    }
    
ERROR:
    
    if (nil != phoneMulti){
        CFRelease(phoneMulti);
        
        phoneMulti = nil;
    }
    
    if (nil != allContacts){
        CFRelease(allContacts);
        
        allContacts = nil;
    }
    
    if (addressBookRef) {
        CFRelease(addressBookRef);
    }
    
    return mutableArray;
}

+ (CFArrayRef) getSearchRecordArray:(NSString*) str{
    if (str == nil){
        return nil;
    }
    
    ABAddressBookRef addressBookRef = nil;
    
        addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_semaphore_signal(sema);
                                                 });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        dispatch_release(sema);

    
    CFMutableArrayRef dataArray = nil;
    
    ABMutableMultiValueRef phoneMulti = nil;
    
    if (nil == addressBookRef) {
        ZBLog(@"getSearchRecordArray addressBookRef is nil");
        return nil;
    }
    
    CFArrayRef allContacts = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    
    if (nil == allContacts) {
        ZBLog(@"getSearchRecordArray allContacts is nil");
        goto ERROR;
    }
    
    dataArray = CFArrayCreateMutable(NULL, 0, NULL);
    
    for (id contact in (NSArray *) allContacts)
    {
        NSString *firstname = nil;
        
        NSString *lastname = nil;
        
        NSRange range;
        
        firstname = [(NSString *)ABRecordCopyValue(contact, kABPersonFirstNameProperty) autorelease];
        
        lastname = [(NSString *)ABRecordCopyValue(contact, kABPersonLastNameProperty) autorelease];
        
        range = [firstname rangeOfString:str];
        
        if (range.length > 0){// 0 && range.location > 0) {
            //  recId = ABRecordGetRecordID(contact);
            
            CFArrayAppendValue(dataArray, contact);
            continue;
            
        }
        
        //    ZBLog(@"[%d][%d]", range.length, range.location);
        
        range = [lastname rangeOfString:str];
        
        if (range.length > 0 ){//&& range.location > 0) {
            //     recId = ABRecordGetRecordID(contact);
            
            CFArrayAppendValue(dataArray, contact);
            continue;
        }
        
        //    ZBLog(@"[%d][%d]", range.length, range.location);
        
        [firstname compare:str options:NSAnchoredSearch range:range];
        
        
        //号码
        phoneMulti = ABRecordCopyValue(contact, kABPersonPhoneProperty);
        
        for (int i = 0;  i < ABMultiValueGetCount(phoneMulti);  i++) {
            NSString *phone = [(NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, i) autorelease];
            
            NSMutableString *phonestr = [[NSMutableString alloc] initWithString:phone];
            
//            if (![MyString checkIsNumberString:phonestr]) {
//                [MyString filterToNumberString:phonestr];
//            }
            
            range = [phonestr rangeOfString:str];
            
            [phonestr release];
            
            if (range.length > 0){// && range.location > 0) {
                //    recId = ABRecordGetRecordID(contact);
                
                CFArrayAppendValue(dataArray, contact);
                
                break;
                
            }
        }
        
        if (nil != phoneMulti){
            CFRelease(phoneMulti);
            
            phoneMulti = nil;
        }
    }
    
ERROR:
    
    if (nil != phoneMulti){
        CFRelease(phoneMulti);
        
        phoneMulti = nil;
    }
    
    if (nil != allContacts){
        CFRelease(allContacts);
        
        allContacts = nil;
    }
    
    if (addressBookRef) {
        CFRelease(addressBookRef);
    }
    
    return dataArray;
}

+ (NSMutableArray*) getSearchAllContact{
    HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication]delegate];
    ABAddressBookRef addressBookRef = delegate.getAddressBookRef;
    
    
    NSMutableArray * mutableArray = nil;
    
    ABMutableMultiValueRef phoneMulti = nil;
    
    if (nil == addressBookRef) {
        ZBLog(@"getSearchAllContact addressBookRef is nil");
        return nil;
    }
    
    CFArrayRef allContacts = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    
    if (nil == allContacts) {
        ZBLog(@"getSearchAllContact allContacts is nil");
        goto ERROR;
    }
    
    mutableArray = [NSMutableArray arrayWithCapacity:(NSUInteger)CFArrayGetCount(allContacts)];
    
    //创建SearchItem用来存放联系人数据
    for (id contact in (NSArray *) allContacts)
    {
        SearchItem *searchItem = [SearchItem searchItemAlloc];
        
        searchItem.rangeArray = [[[NSMutableArray alloc]init] autorelease];
        //名字
        searchItem.contactFirstName = [(NSString *)ABRecordCopyValue(contact, kABPersonFirstNameProperty) autorelease];
        
        searchItem.contactFirstName = [searchItem.contactFirstName stringByReplacingOccurrencesOfString:@" " withString:@""];//去掉 空格
        
        searchItem.contactLastName = [(NSString *)ABRecordCopyValue(contact, kABPersonLastNameProperty) autorelease];
        
        //号码
        phoneMulti = ABRecordCopyValue(contact, kABPersonPhoneProperty);
      
        searchItem.contactPhoneArray = [[[NSMutableArray alloc]init]autorelease];
        
        for (int i = 0;  i < ABMultiValueGetCount(phoneMulti);  i++){
            NSString *phone = [(NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, i) autorelease];
            
            NSMutableString *phone1 = [[NSMutableString alloc] initWithString:phone];
            
            [searchItem.contactPhoneArray addObject:phone1];
            
            [phone1 release];
        }
        
        if (nil != phoneMulti){
            CFRelease(phoneMulti);
            
            phoneMulti = nil;
        }
        
        //ID
        searchItem.contactID = (NSInteger)ABRecordGetRecordID(contact);
        
        searchItem.contactType = -1;
        
        searchItem.contactGroupID = -1;
        
        //    无姓名用户强制加姓名    /////////////////
        if (searchItem.contactFirstName == nil && searchItem.contactLastName == nil){
            if ([searchItem.contactPhoneArray count] > 0){
                searchItem.contactFirstName = [searchItem.contactPhoneArray objectAtIndex:0];
            }
            else if([ContactData getRecordEmailByID:searchItem.contactID]){
                searchItem.contactFirstName = [ContactData getRecordEmailByID:searchItem.contactID];
            }
            else{
                searchItem.contactFirstName = @"未命名";
            }
            
            ABRecordSetValue(contact, kABPersonFirstNameProperty, searchItem.contactFirstName, nil);
        }
        
        //搜索的字符串
        NSString *str = @"未命名";
        
        if ([searchItem.contactLastName length] > 0 && searchItem.contactFirstName > 0){
            str = [NSString stringWithFormat:@"%@%@", searchItem.contactLastName, searchItem.contactFirstName];
        }
        else if ([searchItem.contactLastName length] > 0){
            str = [NSString stringWithFormat:@"%@", searchItem.contactLastName];
        }
        else if ([searchItem.contactFirstName length] > 0){
            str = [NSString stringWithFormat:@"%@", searchItem.contactFirstName];
        }
        
        searchItem.contactFullName = [NSString stringWithString:str];
        
        searchItem.contactSearch = [[ChineseToPinYin pinyinFromChiniseString:str] uppercaseString];///  转换成拼音
        
        searchItem.contactSearchSimple = [[ChineseToPinYin pinyinSimpleChiniseString:str] uppercaseString]; //转换成简拼(重力 ZL)
        
        //new:
        searchItem.contactT9Search = [[PinYinToT9Number pinyinToT9Number:searchItem.contactSearch] uppercaseString];
        
        searchItem.contactT9SearchSimple = [[PinYinToT9Number pinyinToT9Number:searchItem.contactSearchSimple] uppercaseString];
        
        if ([str canBeConvertedToEncoding:NSASCIIStringEncoding]){
            searchItem.chineseFirstName = [NSString stringWithFormat:@".%@",searchItem.contactSearch];
        }
        else{
            NSString* chFirstName = [str substringToIndex:1];
            
            searchItem.chineseFirstName =
            [[[NSString  alloc] initWithFormat:@"%@.%@%@",[ChineseToPinYin pinyinFromChiniseString:chFirstName],chFirstName,[ChineseToPinYin pinyinFromChiniseString:[str substringFromIndex:1]]]autorelease];
            
        }

        
        [mutableArray addObject:searchItem];
        
        // [searchItem release];
    }
    
    
ERROR:
    
    if (nil != phoneMulti){
        CFRelease(phoneMulti);
        
        phoneMulti = nil;
    }
    
    if (nil != allContacts){
        CFRelease(allContacts);
        
        allContacts = nil;
    }
    
    return mutableArray;
}

+ (SearchItem*) getRecordSearchItemByID:(NSInteger) personID{
    SearchItem* searchItem = nil;
    
    ABMutableMultiValueRef phoneMulti = nil;
    
    ABAddressBookRef addressBookRef = nil;
    
  
        addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_semaphore_signal(sema);
                                                 });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        dispatch_release(sema);
    
    
    if (nil == addressBookRef) {
        ZBLog(@"getRecordSearchItemByID addressBookRef is nil");
        goto ERROR;
    }
    
    ABRecordRef contact = ABAddressBookGetPersonWithRecordID(addressBookRef, personID);
    
    if (nil == contact) {
        ZBLog(@"getRecordSearchItemByID contact is nil");
        goto ERROR;
    }
    
    searchItem = [SearchItem searchItemAlloc];
    
    //名字
    searchItem.contactFirstName = [(NSString *)ABRecordCopyValue(contact, kABPersonFirstNameProperty) autorelease];
    
    searchItem.contactLastName = [(NSString *)ABRecordCopyValue(contact, kABPersonLastNameProperty) autorelease];
    
    //号码
    phoneMulti = ABRecordCopyValue(contact, kABPersonPhoneProperty);
    
    searchItem.contactPhoneArray = [[[NSMutableArray alloc]init]autorelease];
    
    for (int i = 0;  i < ABMultiValueGetCount(phoneMulti);  i++) {
        NSString *phone = [(NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, i) autorelease];
        
        NSMutableString *phone1 = [[NSMutableString alloc] initWithString:phone];
        
//        if (![MyString checkIsNumberString:phone1]) {
//            [MyString filterToNumberString:phone1];
//        }
        
        [searchItem.contactPhoneArray addObject:phone1];
        
        [phone1 release];
    }
    
    //Email
    ABMutableMultiValueRef emailMulti = ABRecordCopyValue(contact, kABPersonEmailProperty);
    
    searchItem.contactEmailArray = [[[NSMutableArray alloc]init]autorelease];
    
    for (int i = 0;i < ABMultiValueGetCount(emailMulti); i++){
        NSString *emailAdress = [(NSString*)ABMultiValueCopyValueAtIndex(emailMulti, i) autorelease];
        
        if (emailAdress) {
            [ searchItem.contactEmailArray  addObject:emailAdress];
        }
    }
    
    if (nil != emailMulti){
        CFRelease(emailMulti);
        
        emailMulti = nil;
    }
    
    
    //ID
    searchItem.contactID = personID;
    
    searchItem.contactType = -3;
    
    searchItem.contactGroupID = -1;
    //最后修改时间
    searchItem.contactLastSaveTime = [(NSString*)ABRecordCopyValue(contact, kABPersonModificationDateProperty) autorelease];
    
ERROR:
    if (phoneMulti != nil) {
        CFRelease(phoneMulti);
    }
    
    CFRelease(addressBookRef);
    
    return searchItem;
}

+ (SearchItem *)getSearchItemByRecordId:(NSInteger)recordId{
    if (recordId < 0) {
        return nil;
    }
    
    HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication] delegate];
    ABAddressBookRef addressBookRef = delegate.getAddressBookRef;
    
    if (nil == addressBookRef) {
        ZBLog(@"getRecordCompnyByID addressBookRef is nil");
        return nil;
    }
    
    SearchItem *searchItem = [SearchItem searchItemAlloc];
    
    ABMutableMultiValueRef phoneMulti = nil;
    
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBookRef, recordId);
    //名字
    searchItem.contactFirstName = [(NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty) autorelease];

    
    searchItem.contactLastName = [(NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty) autorelease];
    
    if ([searchItem.contactLastName length] > 0 && searchItem.contactFirstName > 0)
    {
        searchItem.contactFullName = [NSString stringWithFormat:@"%@%@",
                                      searchItem.contactLastName, searchItem.contactFirstName];
    }
    else if ([searchItem.contactLastName length] > 0)
    {
        searchItem.contactFullName = [NSString stringWithFormat:@"%@", searchItem.contactLastName];
    }
    else if ([searchItem.contactFirstName length] > 0){
        searchItem.contactFullName = [NSString stringWithFormat:@"%@", searchItem.contactFirstName];
    }
    else{
        searchItem.contactFullName = @"未命名";
    }
    
    //号码
    phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    searchItem.contactPhoneArray = [[[NSMutableArray alloc]init]autorelease];
    
    for (int i = 0;  i < ABMultiValueGetCount(phoneMulti);  i++) {
        
        NSString *phone = [(NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, i) autorelease];
        
        NSMutableString *phone1 = [[NSMutableString alloc] initWithString:phone];
        
        [searchItem.contactPhoneArray addObject:phone1];
        
        [phone1 release];
    }
    
    if (nil != phoneMulti){
        CFRelease(phoneMulti);
        
        phoneMulti = nil;
    }
    
    //Email
    ABMutableMultiValueRef emailMulti = ABRecordCopyValue(person, kABPersonEmailProperty);
    
    searchItem.contactEmailArray = [[[NSMutableArray alloc]init]autorelease];
    
    for (int i = 0;i < ABMultiValueGetCount(emailMulti); i++){
        NSString *emailAdress = [(NSString*)ABMultiValueCopyValueAtIndex(emailMulti, i) autorelease];
        
        if (emailAdress) {
            [ searchItem.contactEmailArray  addObject:emailAdress];
        }
    }
    
    if (nil != emailMulti){
        CFRelease(emailMulti);
        
        emailMulti = nil;
    }
    
    //ID
    searchItem.contactID = (NSInteger)ABRecordGetRecordID(person);
    
    searchItem.contactType = -3;
    
    searchItem.contactGroupID = -1;
    
    //最后修改时间
    searchItem.contactLastSaveTime = [(NSString*)ABRecordCopyValue(person, kABPersonModificationDateProperty) autorelease];
    
    return searchItem;
}

+ (SearchItem*) getSearchItemByRecord:(ABRecordRef) person{ //Bug 不能传ABRecordRef 地址可能不同
    
    if (person == nil) {
        return nil;
    }
    
    SearchItem* searchItem = [SearchItem searchItemAlloc];
    
    ABMutableMultiValueRef phoneMulti = nil;
    
    //名字
    searchItem.contactFirstName = [(NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty) autorelease];
    
    searchItem.contactLastName = [(NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty) autorelease];
    
    if ([searchItem.contactLastName length] > 0 && searchItem.contactFirstName > 0)
    {
        searchItem.contactFullName = [NSString stringWithFormat:@"%@%@",
                                      searchItem.contactLastName, searchItem.contactFirstName];
    }
    else if ([searchItem.contactLastName length] > 0)
    {
        searchItem.contactFullName = [NSString stringWithFormat:@"%@", searchItem.contactLastName];
    }
    else if ([searchItem.contactFirstName length] > 0){
        searchItem.contactFullName = [NSString stringWithFormat:@"%@", searchItem.contactFirstName];
    }
    else{
        searchItem.contactFullName = @"未命名";
    }
    
    //号码
    phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    searchItem.contactPhoneArray = [[[NSMutableArray alloc]init]autorelease];
    
    for (int i = 0;  i < ABMultiValueGetCount(phoneMulti);  i++) {
        
        NSString *phone = [(NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, i) autorelease];
        
        NSMutableString *phone1 = [[NSMutableString alloc] initWithString:phone];
        
//        if (![MyString checkIsNumberString:phone1]) {
//            [MyString filterToNumberString:phone1];
//        }
        
        [searchItem.contactPhoneArray addObject:phone1];
        
        [phone1 release];
    }
    
    if (nil != phoneMulti){
        CFRelease(phoneMulti);
        
        phoneMulti = nil;
    }
    
    //Email
    ABMutableMultiValueRef emailMulti = ABRecordCopyValue(person, kABPersonEmailProperty);
    
    searchItem.contactEmailArray = [[[NSMutableArray alloc]init]autorelease];
    
    for (int i = 0;i < ABMultiValueGetCount(emailMulti); i++){
        NSString *emailAdress = [(NSString*)ABMultiValueCopyValueAtIndex(emailMulti, i) autorelease];
        
        if (emailAdress) {
            [ searchItem.contactEmailArray  addObject:emailAdress];
        }
    }
    
    if (nil != emailMulti){
        CFRelease(emailMulti);
        
        emailMulti = nil;
    }
    
    //ID
    searchItem.contactID = (NSInteger)ABRecordGetRecordID(person);
    
    searchItem.contactType = -3;
    
    searchItem.contactGroupID = -1;
    
    //最后修改时间
    searchItem.contactLastSaveTime = [(NSString*)ABRecordCopyValue(person, kABPersonModificationDateProperty) autorelease];
    
    return searchItem;
}

+ (BOOL)IsExistContact:(NSInteger)contactId{
    HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    ABAddressBookRef addressBook = delegate.getAddressBookRef;
    
    if(addressBook == nil) {
        return NO;
    }
    
    ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook, contactId);
    
    if(person == nil) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)IsAddressBookChange{
	ABAddressBookRef addressBook = nil;
    
   
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_semaphore_signal(sema);
                                                 });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        dispatch_release(sema);
    
    
    if(addressBook == nil) {
        return NO;
    }
    
    BOOL bReturn = ABAddressBookHasUnsavedChanges(addressBook);
    
    
    CFRelease(addressBook);
    
    return bReturn;
}

+ (NSMutableArray*) getPersonAllID{
    HBZSAppDelegate *delegate = (HBZSAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    ABAddressBookRef addressBookRef = delegate.getAddressBookRef;
    
    NSMutableArray *mutableArray = nil;
    
    if (nil == addressBookRef) {
        ZBLog(@"getPersonAllID addressBookRef is nil");
        return nil;
    }
    
    CFArrayRef allContacts = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    
    if (nil == allContacts) {
        ZBLog(@"getPersonAllID allContacts is nil");
        goto ERROR;
    }
    
    mutableArray = [NSMutableArray arrayWithCapacity:(NSUInteger)CFArrayGetCount(allContacts)];
    
    //NSString *strID = nil;
    for (id contact in (NSArray *) allContacts)
    {
        [mutableArray addObject:[NSString stringWithFormat:@"%d", ABRecordGetRecordID(contact)]];
    }
    
ERROR:
    
    if (nil != allContacts){
        CFRelease(allContacts);
        
        allContacts = nil;
    }
    
    return mutableArray;
}

+ (NSMutableArray*) getPersonSaveLastTime:(NSArray*) personIDArray{
    if (nil == personIDArray || [personIDArray count] <= 0)
        return nil;
    
    ABAddressBookRef addressBookRef = nil;
    
        addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_semaphore_signal(sema);
                                                 });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        dispatch_release(sema);

    NSMutableArray *mutableArray = nil;
    
    if (nil == addressBookRef) {
        ZBLog(@"getPersonSaveLastTime addressBookRef is nil");
        return nil;
    }
    
    mutableArray = [[[NSMutableArray alloc]init]autorelease];
    
    ABRecordRef record = nil;
    
    NSString *strID = nil;
    
    NSString *strTime = nil;
    
    for (NSInteger i = 0; i < [personIDArray count]; i ++) {
        strID = [personIDArray objectAtIndex:i];
        
        record = ABAddressBookGetPersonWithRecordID(addressBookRef, (ABRecordID)[strID intValue]);
        
        if (nil != record) {
            strTime = [(NSString*)ABRecordCopyValue(record, kABPersonModificationDateProperty)autorelease];
            
            [mutableArray addObject:strTime];
        }
    }
    
ERROR:
    
    CFRelease(addressBookRef);
    return mutableArray;
}

+ (NSMutableArray*) getSearchByArrayID:(NSMutableArray*) arrayID{
    
    if (nil == arrayID || [arrayID count] <= 0) {
        return nil;
    }
    
    ABAddressBookRef addressBookRef = nil;
    
  
        addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_semaphore_signal(sema);
                                                 });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        dispatch_release(sema);
    
    
    NSMutableArray *mutableArray = nil;
    
    if (nil == addressBookRef) {
        ZBLog(@"getSearchByArrayID addressBookRef is nil");
        return nil;
    }
    
    mutableArray = [NSMutableArray arrayWithCapacity:[arrayID count]];
    
    NSString *strID = nil;
    
    ABRecordRef contact = nil;
    
    ABMutableMultiValueRef phoneMulti = nil;
    
    for (NSInteger i = 0; i < [arrayID count]; i ++) {
        strID = [arrayID objectAtIndex:i];
        
        contact = ABAddressBookGetPersonWithRecordID(addressBookRef, [strID intValue]);
        
        if (nil != contact) {
            SearchItem *searchItem = [SearchItem searchItemAlloc];
            
            //名字
            searchItem.contactFirstName = [(NSString *)ABRecordCopyValue(contact, kABPersonFirstNameProperty) autorelease];
            
            searchItem.contactLastName = [(NSString *)ABRecordCopyValue(contact, kABPersonLastNameProperty) autorelease];
            
            //号码
            phoneMulti = ABRecordCopyValue(contact, kABPersonPhoneProperty);
            
            searchItem.contactPhoneArray = [[[NSMutableArray alloc]init]autorelease];
            
            for (int i = 0;  i < ABMultiValueGetCount(phoneMulti);  i++)
            {
                NSString *phone = [(NSString*)ABMultiValueCopyValueAtIndex(phoneMulti, i) autorelease];
                
                NSMutableString *phone1 = [[NSMutableString alloc] initWithString:phone];
                
//                if (![MyString checkIsNumberString:phone1]) {
//                    [MyString filterToNumberString:phone1];
//                }
                
                [searchItem.contactPhoneArray addObject:phone1];
                
                [phone1 release];
            }
            
            //Email
            ABMutableMultiValueRef emailMulti = ABRecordCopyValue(contact, kABPersonEmailProperty);
            
            searchItem.contactEmailArray = [[[NSMutableArray alloc]init]autorelease];
            
            for (int i = 0;i < ABMultiValueGetCount(emailMulti); i++){
                NSString *emailAdress = [(NSString*)ABMultiValueCopyValueAtIndex(emailMulti, i) autorelease];
                
                if (emailAdress) {
                    [ searchItem.contactEmailArray  addObject:emailAdress];
                }
            }
            
            if (nil != emailMulti){
                CFRelease(emailMulti);
                
                emailMulti = nil;
            }
            
            
            //ID
            searchItem.contactID = [strID intValue];
            
            searchItem.contactType = -1;
            
            searchItem.contactGroupID = -1;
            
            //最后修改时间
            searchItem.contactLastSaveTime = [(NSString*)ABRecordCopyValue(contact, kABPersonModificationDateProperty) autorelease];
            
            NSString *str = nil;
            
            if ([searchItem.contactLastName length] > 0 && searchItem.contactFirstName > 0)
            {
                str = [NSString stringWithFormat:@"%@%@", searchItem.contactLastName, searchItem.contactFirstName];
            }
            else if ([searchItem.contactLastName length] > 0)
            {
                str = [NSString stringWithFormat:@"%@", searchItem.contactLastName];
            }
            else if ([searchItem.contactFirstName length] > 0)
            {
                str = [NSString stringWithFormat:@"%@", searchItem.contactFirstName];
            }
            
            searchItem.contactSearch = [ChineseToPinYin pinyinFromChiniseString:str];
            
            searchItem.contactSearchSimple = [ChineseToPinYin pinyinSimpleChiniseString:str];
            
            [mutableArray addObject:searchItem];
            
            if (nil != phoneMulti) {
                CFRelease(phoneMulti);
                
                phoneMulti = nil;
            }
        }
    }
ERROR:
    CFRelease(addressBookRef);
    return mutableArray;
}

//判断号码是否在指定联系人中
+ (BOOL)IsPhoneExistRecordContact:(NSUInteger) recordID phoneStr:(NSString*) phoneStr{
    
    if (recordID <= 0 || phoneStr == nil || [phoneStr length] <= 0)
    {
        ZBLog(@"IsPhoneExistRecordContact prarm error");
        return NO;
    }
    
    
    BOOL bIsExist = NO;
    
    ABMutableMultiValueRef phoneMulti = nil;
    
	ABAddressBookRef addressBookRef = nil;
    
  
        addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_semaphore_signal(sema);
                                                 });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        dispatch_release(sema);
    

    
    if (addressBookRef == nil) {
        ZBLog(@"IsPhoneExistRecordContact addressBookRef == nil");
        goto ERROR;
    }
    
    ABRecordRef recordRef = ABAddressBookGetPersonWithRecordID(addressBookRef, recordID);
    
    if (recordRef != nil) {
        //号码
        phoneMulti = ABRecordCopyValue(recordRef, kABPersonPhoneProperty);
        
        for (int i = 0;  i < ABMultiValueGetCount(phoneMulti);  i++) {
            NSMutableString *phone = [(NSMutableString*)ABMultiValueCopyValueAtIndex(phoneMulti, i) autorelease];
            
            NSMutableString *phone1 = [[NSMutableString alloc] initWithString:phone];
            
//            if (![MyString checkIsNumberString:phone1]) {
//                [MyString filterToNumberString:phone1];
//            }
            
            
            if ([phone1 isEqualToString:phoneStr]) {
                bIsExist = YES;
                
                [phone1 release];
                
                goto ERROR;
            }
            
            [phone1 release];
        }
        
        if (nil != phoneMulti) {
            CFRelease(phoneMulti);
            
            phoneMulti = nil;
        }
    }
    
ERROR:
    
    if (nil != phoneMulti) {
        CFRelease(phoneMulti);
        
        phoneMulti = nil;
    }
    
    if (addressBookRef) {
        CFRelease(addressBookRef);
    }
    
    return bIsExist;
}

@end
