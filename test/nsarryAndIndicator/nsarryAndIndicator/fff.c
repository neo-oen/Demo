//
//  fff.c
//  nsarryAndIndicator
//
//  Created by neo on 2017/10/30.
//  Copyright © 2017年 neo. All rights reserved.
//

#include "fff.h"

int a[4] = {1,2,3,4};
int b[7] = {5,6,7,8,9};

int b[3] = 10;





int *p = &a[3];
int *c = &b[3];
a[3] = p[3];

&b[3] = &a[3];
