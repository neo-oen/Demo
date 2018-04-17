/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"

@implementation UIImageView (WebCache)


- (void)setImageWithURL:(NSURL *)url
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
    spinner.backgroundColor = [UIColor whiteColor];
    spinner.center = self.center;
    [self addSubview:spinner];
    [spinner release];
    [spinner startAnimating];

    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;
    
    if (url)
    {
        [manager downloadWithURL:url delegate:self];
    }
}

- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    self.contentMode = UIViewContentModeScaleToFill;

    self.image = image;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIActivityIndicatorView class]]) {
            UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)view;
            [activityView stopAnimating];
        }
    }
}

@end
