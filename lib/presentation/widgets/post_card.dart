import 'package:flutter/material.dart';
import 'package:flutter_fullstack/data/models/post_model.dart';
import 'package:flutter_fullstack/core/theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback? onJoin;
  final VoidCallback? onUserTap;

  const PostCard({
    Key? key,
    required this.post,
    required this.onLike,
    required this.onComment,
    this.onJoin,
    this.onUserTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      elevation: 0,
      color: Theme.of(context).brightness == Brightness.light
          ? const Color(0xFFFAF6FB)
          : const Color(0xFF1B1D24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author section
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // Profile picture
                  GestureDetector(
                    onTap: onUserTap,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryColor.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: AppTheme.primaryColor.withOpacity(0.15),
                        child: Text(
                          post.author.username.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Username, bio, and date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.author.username,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (post.author.bio != null)
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: SvgPicture.string(
                                  '''
<svg width="16" height="12" viewBox="0 0 16 12" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M7.92936 5.40353C9.38422 5.40353 10.5638 4.22424 10.5638 2.76905C10.5638 1.31385 9.38422 0.134903 7.92936 0.134903C6.4745 0.134903 5.29488 1.31419 5.29488 2.76938V2.77005C5.29654 4.22424 6.47516 5.40253 7.92936 5.40386V5.40353ZM7.92936 1.20189C8.79541 1.20189 9.49751 1.904 9.49751 2.77005C9.49751 3.6361 8.79541 4.33821 7.92936 4.33821C7.0633 4.33821 6.3612 3.6361 6.3612 2.77005C6.36253 1.90466 7.06364 1.20322 7.92936 1.20189ZM2.95297 6.95203C4.07194 6.95203 4.97898 6.04499 4.97898 4.92602C4.97898 3.80705 4.07194 2.90001 2.95297 2.90001C1.834 2.90001 0.926961 3.80705 0.926961 4.92602C0.926961 6.04499 1.834 6.95203 2.95297 6.95203ZM2.95297 3.96633C3.48313 3.96633 3.91266 4.39585 3.91266 4.92602C3.91266 5.45618 3.48313 5.88571 2.95297 5.88571C2.42281 5.88571 1.99328 5.45618 1.99328 4.92602C1.99328 4.39585 2.42281 3.96633 2.95297 3.96633ZM12.9054 6.95203C14.0244 6.95203 14.9314 6.04499 14.9314 4.92602C14.9314 3.80705 14.0244 2.90001 12.9054 2.90001C11.7864 2.90001 10.8794 3.80705 10.8794 4.92602C10.8794 6.04499 11.7864 6.95203 12.9054 6.95203ZM12.9054 3.96633C13.4356 3.96633 13.8651 4.39585 13.8651 4.92602C13.8651 5.45618 13.4356 5.88571 12.9054 5.88571C12.3752 5.88571 11.9457 5.45618 11.9457 4.92602C11.9457 4.39585 12.3752 3.96633 12.9054 3.96633ZM12.9764 8.02135C12.5089 8.02435 12.0497 8.14397 11.6402 8.36957C10.8494 7.11764 9.48085 6.34856 8.00033 6.3239C6.51981 6.34856 5.15126 7.11764 4.36051 8.36957C3.95098 8.14431 3.4918 8.02435 3.02428 8.02135C1.27818 8.10665 -0.0713822 9.58551 0.00292706 11.3319C0.00292706 11.6265 0.241516 11.8651 0.536088 11.8651C0.830659 11.8651 1.06925 11.6265 1.06925 11.3319C0.996605 10.1746 1.86799 9.17431 3.02428 9.088C3.31885 9.09033 3.60809 9.16698 3.86501 9.31126C3.61376 9.94439 3.48513 10.6198 3.4858 11.301C3.4858 11.5955 3.72439 11.8341 4.01896 11.8341C4.31353 11.8341 4.55212 11.5955 4.55212 11.301C4.55212 9.14432 6.09828 7.39022 8 7.39022C9.90172 7.39022 11.4479 9.14432 11.4479 11.301C11.4479 11.5955 11.6865 11.8341 11.981 11.8341C12.2756 11.8341 12.5142 11.5955 12.5142 11.301C12.5152 10.6198 12.3862 9.94439 12.135 9.31126C12.3919 9.16698 12.6811 9.09 12.9757 9.088C14.132 9.17464 15.0034 10.175 14.9308 11.3319C14.9308 11.6265 15.1693 11.8651 15.4639 11.8651C15.7585 11.8651 15.9971 11.6265 15.9971 11.3319C16.0714 9.58551 14.7215 8.10665 12.9757 8.02168L12.9764 8.02135Z" fill="currentColor"/>
</svg>
                                  ''',
                                  width: 16,
                                  height: 12,
                                  colorFilter: ColorFilter.mode(
                                    theme.colorScheme.onSurface.withOpacity(0.35),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  post.author.bio!,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  // Join button
                  if (!post.isJoined && onJoin != null)
                    ElevatedButton(
                      onPressed: onJoin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xfffe8964),
                        foregroundColor: Colors.black,
                        elevation: 0,
                        textStyle: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text('Join'),
                    )
                  else if (post.isJoined)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xff6c3bfb),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Joined',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            // Post content
            if (post.imageUrl != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.asset(
                      'lib/data/images/${post.imageUrl}.${post.imageUrl!.startsWith('figma') ? 'jpeg' : 'png'}',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            // Post text content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Post text content with hashtag highlighted
                  if (post.content.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: _buildRichTextContent(context, post.content, post.hashtag),
                    ),
                  const SizedBox(height: 20),
                  // Actions row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Action buttons row
                      Row(
                        children: [
                          // Share button
                          GestureDetector(
                            onTap: () {},
                            child: SvgPicture.string(
                              '''
<svg width="18" height="18" viewBox="0 0 18 18" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M17.4886 0.511677C17.0506 0.0736337 16.4301 -0.0975758 15.8307 0.0542979L1.31727 3.70876C0.573719 3.89614 0.0460284 4.53598 0.00313814 5.30167C-0.039049 6.06702 0.414463 6.76205 1.13235 7.03064L8.2915 9.70847L10.9693 16.8676C11.226 17.5546 11.8732 18 12.5992 18C12.6322 18 12.6656 17.9993 12.6987 17.9972C13.4647 17.9546 14.1045 17.4263 14.2916 16.6827L17.946 2.16963C18.0972 1.56917 17.9263 0.949368 17.4886 0.511677ZM14.4768 2.25119L8.7647 7.96333L1.93566 5.40925L14.4765 2.25119H14.4768ZM12.5911 16.0647L10.037 9.23597L15.7488 3.52419L12.5911 16.0647Z" fill="currentColor"/>
</svg>
                              ''',
                              width: 22,
                              height: 22,
                              colorFilter: ColorFilter.mode(
                                theme.colorScheme.onSurface.withOpacity(0.7),
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          // Comment button
                          Row(
                            children: [
                              Text(
                                post.comments.toString(),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: onComment,
                                child: SvgPicture.string(
                                  '''
<svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M9.06622 11.0914C9.06622 11.6022 8.65735 12.0202 8.13744 12.0202C7.61753 12.0202 7.20865 11.6022 7.20865 11.0914C7.20865 10.5807 7.62667 10.1626 8.13744 10.1626C8.6482 10.1626 9.06622 10.5807 9.06622 11.0914ZM11.1097 10.1626C10.599 10.1626 10.1809 10.5807 10.1809 11.0914C10.1809 11.6022 10.5898 12.0202 11.1097 12.0202C11.6296 12.0202 12.0385 11.6022 12.0385 11.0914C12.0385 10.5807 11.6205 10.1626 11.1097 10.1626ZM5.17386 10.1626C4.6631 10.1626 4.24508 10.5807 4.24508 11.0914C4.24508 11.6022 4.65395 12.0202 5.17386 12.0202C5.69377 12.0202 6.10265 11.6022 6.10265 11.0914C6.10265 10.5807 5.68463 10.1626 5.17386 10.1626ZM19.9813 5.14642V8.86199C19.9813 12.4173 18.0083 13.5847 16.1421 13.9004C15.8351 15.7471 14.6685 17.724 11.1097 17.724H10.7383L9.58657 19.2288C9.22429 19.7213 8.6948 20 8.13744 20C7.58008 20 7.05059 19.7213 6.68831 19.2288L5.57359 17.7427C5.57359 17.7518 5.527 17.724 5.50871 17.724H5.16515C1.98821 17.724 0.0187378 16.8601 0.0187378 12.5776V8.86199C0.0187378 5.31058 1.98734 4.14143 3.85188 3.82443C4.16539 1.96251 5.34368 0 8.88987 0H14.8349C18.1977 0 19.9813 1.78354 19.9813 5.14642ZM14.8253 13.2185C14.8532 12.9956 14.8623 12.7914 14.8623 12.5776V8.86199C14.8623 6.27028 13.701 5.10897 11.1093 5.10897H5.17386C4.96006 5.10897 4.75584 5.11811 4.56077 5.13684C4.54945 5.13858 4.53769 5.13858 4.52593 5.13945C2.38881 5.33235 1.41126 6.51194 1.41126 8.86199V12.5776C1.41126 15.7636 2.39578 16.3306 5.16428 16.3306H5.53571C5.95373 16.3306 6.42748 16.5627 6.68744 16.8971L7.80215 18.3928C8.00637 18.6715 8.26676 18.6715 8.47098 18.3928L9.5857 16.9067C9.85523 16.5444 10.2824 16.3306 10.7374 16.3306H11.1089C13.4685 16.3306 14.6481 15.3365 14.8244 13.2185H14.8253ZM18.5783 5.14642C18.5783 2.5547 17.417 1.39339 14.8253 1.39339H8.88029C6.83679 1.39339 5.68463 2.13668 5.28533 3.71557H11.1097C11.2673 3.71557 11.4215 3.71949 11.5722 3.72733C11.6727 3.73256 11.7716 3.73952 11.8687 3.74823C11.9175 3.75259 11.9658 3.75738 12.0137 3.7626C12.4927 3.81442 12.9325 3.90978 13.3326 4.04694C13.3727 4.06087 13.4123 4.07481 13.4515 4.08961C13.765 4.20631 14.0533 4.35 14.3154 4.52026C14.3481 4.54159 14.3807 4.56337 14.4125 4.58557C15.6274 5.42596 16.2561 6.86595 16.2561 8.86242V12.4574C17.8355 12.0672 18.5783 10.9059 18.5783 8.86242V5.14685V5.14642Z" fill="currentColor"/>
</svg>
                                  ''',
                                  width: 22,
                                  height: 22,
                                  colorFilter: ColorFilter.mode(
                                    theme.colorScheme.onSurface.withOpacity(0.7),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          // Coffee button
                          Row(
                            children: [
                              Text(
                                post.comments.toString(),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: () {},
                                child: SvgPicture.string(
                                  '''
<svg width="22" height="16" viewBox="0 0 22 16" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M0.986115 11.3657C0.986115 9.9952 2.26577 8.85941 4.46163 8.13251C4.14361 7.29202 3.96946 6.3531 3.96946 5.33847V3.73322C3.96946 1.7948 6.80136 0.5 10.9962 0.5C15.1532 0.5 17.9624 1.76451 18.023 3.66507C19.6585 3.74836 20.6504 4.67214 20.6504 6.15623C20.6504 7.43589 19.9159 8.30666 18.6666 8.57168C20.1582 9.29101 21.0139 10.2527 21.0139 11.3657C21.0139 13.8266 16.872 15.5 10.9962 15.5C5.13553 15.5 0.986115 13.8266 0.986115 11.3657ZM10.9962 5.56562C14.2143 5.56562 16.6297 4.75543 16.6297 3.73322C16.6297 2.711 14.2219 1.90081 10.9962 1.90081C7.77814 1.90081 5.37026 2.711 5.37026 3.73322C5.37026 4.75543 7.77814 5.56562 10.9962 5.56562ZM18.0305 5.33847C18.0305 6.02751 17.9472 6.6787 17.7958 7.29202C18.7347 7.29202 19.2799 6.86042 19.2799 6.15623C19.2799 5.50505 18.8256 5.10374 18.0305 5.03559V5.33847ZM10.9962 6.96643C8.58076 6.96643 6.61206 6.53483 5.38541 5.79278C5.56713 8.79884 7.55098 10.7903 10.6328 10.7903H11.3597C14.4339 10.7903 16.4329 8.79127 16.6146 5.79278C15.3879 6.53483 13.4192 6.96643 10.9962 6.96643ZM2.33392 11.3657C2.33392 12.8044 6.17289 14.1522 10.9962 14.1522C15.8271 14.1522 19.6661 12.8044 19.6661 11.3657C19.6661 10.6237 18.6287 9.8892 16.9099 9.36673C15.7741 11.1234 13.8205 12.1911 11.3597 12.1911H10.6328C8.17945 12.1911 6.21832 11.1234 5.08253 9.35916C3.3637 9.8892 2.33392 10.6237 2.33392 11.3657Z" fill="currentColor"/>
</svg>
                                  ''',
                                  colorFilter: ColorFilter.mode(
                                    theme.colorScheme.onSurface.withOpacity(0.7),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return Row(
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: onTap,
          child: SvgPicture.string(
            '''
<svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M9.06622 11.0914C9.06622 11.6022 8.65735 12.0202 8.13744 12.0202C7.61753 12.0202 7.20865 11.6022 7.20865 11.0914C7.20865 10.5807 7.62667 10.1626 8.13744 10.1626C8.6482 10.1626 9.06622 10.5807 9.06622 11.0914ZM11.1097 10.1626C10.599 10.1626 10.1809 10.5807 10.1809 11.0914C10.1809 11.6022 10.5898 12.0202 11.1097 12.0202C11.6296 12.0202 12.0385 11.6022 12.0385 11.0914C12.0385 10.5807 11.6205 10.1626 11.1097 10.1626ZM5.17386 10.1626C4.6631 10.1626 4.24508 10.5807 4.24508 11.0914C4.24508 11.6022 4.65395 12.0202 5.17386 12.0202C5.69377 12.0202 6.10265 11.6022 6.10265 11.0914C6.10265 10.5807 5.68463 10.1626 5.17386 10.1626ZM19.9813 5.14642V8.86199C19.9813 12.4173 18.0083 13.5847 16.1421 13.9004C15.8351 15.7471 14.6685 17.724 11.1097 17.724H10.7383L9.58657 19.2288C9.22429 19.7213 8.6948 20 8.13744 20C7.58008 20 7.05059 19.7213 6.68831 19.2288L5.57359 17.7427C5.57359 17.7518 5.527 17.724 5.50871 17.724H5.16515C1.98821 17.724 0.0187378 16.8601 0.0187378 12.5776V8.86199C0.0187378 5.31058 1.98734 4.14143 3.85188 3.82443C4.16539 1.96251 5.34368 0 8.88987 0H14.8349C18.1977 0 19.9813 1.78354 19.9813 5.14642ZM14.8253 13.2185C14.8532 12.9956 14.8623 12.7914 14.8623 12.5776V8.86199C14.8623 6.27028 13.701 5.10897 11.1093 5.10897H5.17386C4.96006 5.10897 4.75584 5.11811 4.56077 5.13684C4.54945 5.13858 4.53769 5.13858 4.52593 5.13945C2.38881 5.33235 1.41126 6.51194 1.41126 8.86199V12.5776C1.41126 15.7636 2.39578 16.3306 5.16428 16.3306H5.53571C5.95373 16.3306 6.42748 16.5627 6.68744 16.8971L7.80215 18.3928C8.00637 18.6715 8.26676 18.6715 8.47098 18.3928L9.5857 16.9067C9.85523 16.5444 10.2824 16.3306 10.7374 16.3306H11.1089C13.4685 16.3306 14.6481 15.3365 14.8244 13.2185H14.8253ZM18.5783 5.14642C18.5783 2.5547 17.417 1.39339 14.8253 1.39339H8.88029C6.83679 1.39339 5.68463 2.13668 5.28533 3.71557H11.1097C11.2673 3.71557 11.4215 3.71949 11.5722 3.72733C11.6727 3.73256 11.7716 3.73952 11.8687 3.74823C11.9175 3.75259 11.9658 3.75738 12.0137 3.7626C12.4927 3.81442 12.9325 3.90978 13.3326 4.04694C13.3727 4.06087 13.4123 4.07481 13.4515 4.08961C13.765 4.20631 14.0533 4.35 14.3154 4.52026C14.3481 4.54159 14.3807 4.56337 14.4125 4.58557C15.6274 5.42596 16.2561 6.86595 16.2561 8.86242V12.4574C17.8355 12.0672 18.5783 10.9059 18.5783 8.86242V5.14685V5.14642Z" fill="currentColor"/>
</svg>
            ''',
            width: 22,
            height: 22,
            colorFilter: ColorFilter.mode(
              theme.colorScheme.onSurface.withOpacity(0.7),
              BlendMode.srcIn,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRichTextContent(BuildContext context, String content, String? hashtag) {
    if (hashtag == null || !content.contains('#$hashtag')) {
      return Text(
        content,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          height: 1.5,
          fontSize: 17,
        ),
      );
    }

    final theme = Theme.of(context);
    final parts = content.split('#$hashtag');
    
    return RichText(
      text: TextSpan(
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurface,
          height: 1.5,
          fontSize: 17,
        ),
        children: [
          TextSpan(text: parts[0]),
          TextSpan(
            text: '#$hashtag',
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          if (parts.length > 1) TextSpan(text: parts[1]),
        ],
      ),
    );
  }
} 