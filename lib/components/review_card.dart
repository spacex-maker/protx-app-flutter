import 'package:flutter/material.dart';
import '../models/product_x_model.dart';

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({
    Key? key,
    required this.review,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: review.userAvatar != null
                      ? NetworkImage(review.userAvatar!)
                      : null,
                  child: review.userAvatar == null
                      ? Text(review.username[0].toUpperCase())
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.username,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            index < review.rating.floor()
                                ? Icons.star
                                : Icons.star_border,
                            size: 16,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  _formatDate(review.createdAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(review.content),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
