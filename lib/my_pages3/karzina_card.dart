import 'package:bamboo/options_item.dart';
import 'package:bamboo/providers/provider_items.dart';
import 'package:bamboo/values/colors.dart';
import 'package:bamboo/values/constants.dart' as constants;
import 'package:bamboo/values/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../providers/page1provider.dart';

class KarzinaCard extends StatefulWidget {
  final int id;
  final String nameTm;
  final String nameRu;
  final String nameEn;
  final String descriptionTm;
  final String descriptionRu;
  final String descriptionEn;
  final String image;
  final double price;
  int count;
  final double rating;
  final int discount;
  final double discountPrice;
  final String category;
  final dynamic values;

  KarzinaCard(
    this.id,
    this.nameTm,
    this.nameRu,
    this.nameEn,
    this.descriptionTm,
    this.descriptionRu,
    this.descriptionEn,
    this.image,
    this.price,
    this.count,
    this.rating,
    this.discount,
    this.discountPrice,
    this.category,
    this.values, {
    super.key,
  });

  @override
  _KarzinaCardState createState() => _KarzinaCardState();
}

class _KarzinaCardState extends State<KarzinaCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _navigateToOptionsItem(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Slidable(
          key: ValueKey(widget.id),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            dismissible: DismissiblePane(onDismissed: () {
              Provider.of<ProvItem>(context, listen: false).removeItem2(widget.id);
            }),
            children: [
              SlidableAction(
                flex: 2,
                onPressed: (context) {}, //context gerekli olduğu için metodu buraya aldım.
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                borderRadius: BorderRadius.circular(20),
              ),
            ],
          ),
          child: _buildCardContent(context),
        ),
      ),
    );
  }

  void _navigateToOptionsItem(BuildContext context) {
    constants.op_id = widget.id;
    constants.op_name_tm = widget.nameTm;
    constants.op_name_ru = widget.nameRu;
    constants.op_name_en = widget.nameEn;
    constants.op_description_tm = widget.descriptionTm;
    constants.op_description_ru = widget.descriptionRu;
    constants.op_description_en = widget.descriptionEn;
    constants.op_image = widget.image;
    constants.op_price = widget.price;
    constants.op_count = widget.count;
    constants.op_rating = widget.rating;
    constants.op_discount = widget.discount;
    constants.op_discount_price = widget.discountPrice;
    constants.op_category = widget.category;
    constants.op_values = widget.values;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OptionsItem(image: widget.image),
      ),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.light_silver,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Visibility(
            visible: false,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 2,
                decoration: const BoxDecoration(
                  color: AppColors.light_silver,
                ),
                child: const Divider(
                  height: 2,
                  color: AppColors.light_silver,
                ),
              ),
            ),
          ),
          Row(
            children: [
              _buildImageContainer(),
              Expanded(
                child: _buildTextContainer(context),
              ),
              _buildCounterContainer(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageContainer() {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: widget.image,
          errorWidget: (context, url, error) => Image.asset(
            logoImage,
            width: 80,
            height: 80,
          ),
        ),
      ),
    );
  }

  Widget _buildTextContainer(BuildContext context) {
    return Container(
      height: 80,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(left: 10, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getProductName(context),
            maxLines: 2,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: gilroyMedium,
              fontSize: 15,
            ),
          ),
          _buildPriceText(),
        ],
      ),
    );
  }

  String _getProductName(BuildContext context) {
    final language = Provider.of<Which_page>(context).dil;
    switch (language) {
      case 1:
        return widget.nameTm;
      case 0:
        return widget.nameRu;
      default:
        return widget.nameEn;
    }
  }

  Widget _buildPriceText() {
    return (widget.discount != 0)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.discountPrice} TMT',
                style: const TextStyle(color: Colors.green, fontFamily: gilroyBold, fontSize: 16),
              ),
              const SizedBox(width: 5),
              Text(
                '${widget.price} TMT',
                style: const TextStyle(color: Colors.black, fontSize: 13, decoration: TextDecoration.lineThrough),
              ),
            ],
          )
        : Text(
            '${widget.price} TMT',
            style: const TextStyle(color: Colors.green, fontFamily: gilroyBold, fontSize: 16),
          );
  }

  Widget _buildCounterContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 20, top: 5, bottom: 5),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMinusButton(context),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: 20,
                  child: Text(
                    _getItemCount(context),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Semi'),
                  ),
                ),
                _buildPlusButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getItemCount(BuildContext context) {
    final itemCount = Provider.of<ProvItem>(context, listen: false).items[widget.id]?.count;
    return itemCount == null ? '0' : itemCount.toString();
  }

  Widget _buildMinusButton(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 30,
      child: FloatingActionButton(
        heroTag: "minusdak${widget.id}",
        hoverElevation: 1.5,
        shape: const StadiumBorder(side: BorderSide(color: Colors.white, width: 2)),
        elevation: 1.5,
        backgroundColor: Colors.white,
        child: Image.asset(
          "assets/images/minus.png",
          color: Colors.black,
          fit: BoxFit.none,
          width: 12,
          height: 12,
        ),
        onPressed: () {
          _decreaseCount(context);
        },
      ),
    );
  }

  void _decreaseCount(BuildContext context) {
    if (widget.count > 0) {
      setState(() {
        widget.count--;
      });
      Provider.of<ProvItem>(context, listen: false).removeItem(widget.id, widget.count);
    }
  }

  Widget _buildPlusButton(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 30,
      child: FloatingActionButton(
        heroTag: "plusdak${widget.id}",
        hoverElevation: 1.5,
        shape: const StadiumBorder(side: BorderSide(color: AppColors.primary, width: 2)),
        elevation: 1.5,
        backgroundColor: AppColors.primary,
        child: Image.asset(
          "assets/images/plus.png",
          color: Colors.white,
          fit: BoxFit.none,
          width: 12,
          height: 12,
        ),
        onPressed: () {
          _increaseCount(context);
        },
      ),
    );
  }

  void _increaseCount(BuildContext context) {
    setState(() {
      widget.count++;
    });
    Provider.of<ProvItem>(context, listen: false).addItem(widget.id, widget.nameTm, widget.nameRu, widget.nameEn, widget.descriptionTm, widget.descriptionRu, widget.descriptionEn, widget.image,
        widget.price, widget.count, widget.rating, widget.discount, widget.discountPrice, widget.category, widget.values);
  }
}
