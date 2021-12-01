package com.aocyun.chuangrtcdemo.adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.aocyun.chuangrtcdemo.R;
import com.aocyun.chuangrtcdemo.beans.TextBean;

import java.util.List;

/**
 * @Author SongTiChao
 * @CreateDate 2021/7/21 9:31
 * Description:
 */
public class TextItemAdapter extends RecyclerView.Adapter<TextItemAdapter.ViewHolder> {
    private Context mContext;
    private List<TextBean> list;
    private OnItemClickListener onItemClickListener;
    private int defaultSelected = -1;

    public TextItemAdapter(Context mContext) {
        this.mContext = mContext;
    }

    public void setData(List<TextBean> list) {
        this.list = list;
        notifyDataSetChanged();
    }

    public void updateSelectedItem(String defaultSelected) {
        this.defaultSelected = -1;
        for (int i = 0; i < list.size(); i++) {
            if (list.get(i).getId().equals(defaultSelected)) {
                this.defaultSelected = i;
            }
        }
        notifyDataSetChanged();
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(mContext).inflate(R.layout.item_text, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull TextItemAdapter.ViewHolder holder, int position) {
        if (defaultSelected == position) {
            holder.textView.setTextColor(mContext.getResources().getColor(R.color.rtc_demo_blue));
        } else {
            holder.textView.setTextColor(mContext.getResources().getColor(R.color.rtc_demo_dark_grey));
        }
        holder.textView.setText(list.get(position).getContent());
        holder.itemView.setOnClickListener(v -> onItemClickListener.onItemClick(position));
    }

    @Override
    public int getItemCount() {
        return list.size();
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        TextView textView;

        public ViewHolder(@NonNull View itemView) {
            super(itemView);
            textView = itemView.findViewById(R.id.itemContent);
        }
    }

    public void setOnItemClickListener(OnItemClickListener onItemClickListener) {
        this.onItemClickListener = onItemClickListener;
    }

    public interface OnItemClickListener {
        void onItemClick(int position);
    }
}
